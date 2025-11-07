# ===========================================================
# 2230.pl – Floor 4 Mini Boss (Cinderweb Matron)
# Invulnerable unless a Phantasmal Key holder is nearby.
# On death: sets mini flag, checks essence/key progression.
# Loot is seeded on first combat engage based on detected era.
# ===========================================================

my $REQ_KEY_ID     = 57162;  # Phantasmal Key (F3→F4)
my $CHECK_RADIUS   = 250;
my $CHECK_INTERVAL = 5;
my $LOOT_SEEDED    = 0;      # ensure loot seeds only once

# -----------------------------------------------------------
# Keyholder / invulnerability helpers
# -----------------------------------------------------------
sub _has_key_inv   { my($c)=@_; return ($c && $c->IsClient() && $c->CountItem($REQ_KEY_ID) > 0) ? 1 : 0; }
sub _has_key_ring  { my($c)=@_; return 0 unless $c && $c->IsClient(); my $ok = 0; eval { $ok = $c->KeyRingCheck($REQ_KEY_ID) ? 1 : 0; }; return $ok; }
sub _client_has_key{ my($c)=@_; return (_has_key_inv($c) || _has_key_ring($c)); }

sub _any_keyholder_nearby {
    my ($npc_ref,$r) = @_;
    return 0 unless $npc_ref;
    foreach my $c ($entity_list->GetClientList()) {
        next unless $c->IsClient();
        next if $npc_ref->CalculateDistance($c->GetX,$c->GetY,$c->GetZ) > $r;
        return 1 if _client_has_key($c);
    }
    return 0;
}

sub _unlock_if_locked {
    return unless $npc && $npc->GetInvul();
    $npc->SetInvul(0);
    $npc->SetSpecialAbility($_,0) for (19,20,22,23,24,25,35,39);
}

sub _lock_if_unlocked {
    return unless $npc && !$npc->GetInvul();
    $npc->SetInvul(1);
    $npc->SetSpecialAbility($_,1) for (19,20,22,23,24,25,35,39);
}

# -----------------------------------------------------------
# Era loot pools
# -----------------------------------------------------------
my %ERA_POOLS = (
    A => [600413,600417,600421,600425,600429,600433],                # Antonica
    K => [600412,600416,600420,600424,600428,600432],                # Kunark
    V => [600411,600415,600419,600423,600427,600431],                # Velious
    L => [600410,600414,600418,600422,600426,600430],                # Luclin
    P => [600434,600435,600436,600437,600438,600439,600440,600441],  # Planes of Power
);

my %ERA_KEY = (
    antonica => 'A',
    kunark   => 'K',
    velious  => 'V',
    luclin   => 'L',
    pop      => 'P',
);

# -----------------------------------------------------------
# GM-aware dynamic era detection
# -----------------------------------------------------------
sub _determine_era_including_gm {
    my ($elist) = @_;
    my $detected = "antonica";
    my @clients = $elist->GetClientList();

    foreach my $c (@clients) {
        next unless $c && $c->IsClient();
        my $era = plugin::DetermineEraForClient($c);
        if ($era) { $detected = $era; last; }
    }
    return $detected;
}

# -----------------------------------------------------------
# EVENT_SPAWN — initialize invuln and keycheck timer
# -----------------------------------------------------------
sub EVENT_SPAWN {
    return unless $npc;
    _lock_if_unlocked();
    quest::settimer("f4_keycheck", $CHECK_INTERVAL);
}

# -----------------------------------------------------------
# EVENT_TIMER — toggle invulnerability based on keyholders
# -----------------------------------------------------------
sub EVENT_TIMER {
    return unless $npc;
    if ($_[0] eq "f4_keycheck") {
        _any_keyholder_nearby($npc,$CHECK_RADIUS)
            ? _unlock_if_locked()
            : _lock_if_unlocked();
    }
}

# -----------------------------------------------------------
# EVENT_COMBAT — unlock + seed loot if not already done
# -----------------------------------------------------------
sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        # Unlock only if a keyholder is nearby
        if (_any_keyholder_nearby($npc, $CHECK_RADIUS)) {
            _unlock_if_locked();
        } else {
            _lock_if_unlocked();
            $npc->WipeHateList();
            return;
        }

        # === Only run once per spawn
        return if $LOOT_SEEDED;
        $LOOT_SEEDED = 1;

        # --- NEW: Check for cursed item wearers (pre-seed Curse Breaker loot)
        my $attacker = $npc->GetHateTop();
        if ($attacker && $attacker->IsClient()) {
            # Prevent double-seeding
            unless ($npc->GetEntityVariable("cursed_seeded")) {
                plugin::CheckForCursedItemsAndSeedLoot($npc, $attacker);
                $npc->SetEntityVariable("cursed_seeded", 1);
            }
        }

        # 50% chance to drop loot
        my $roll = int(rand(100));
        if ($roll >= 50) {
            return; # no loot this time
        }

        # Determine era dynamically
        my $era = _determine_era_including_gm($entity_list);
        my $key = $ERA_KEY{$era} || 'A';

        # Add loot if valid pool found
        if (exists $ERA_POOLS{$key}) {
            my @pool = @{$ERA_POOLS{$key}};
            my $itemid = $pool[int(rand(@pool))];

            my $was_invul = $npc->GetInvul();
            if ($was_invul) { _unlock_if_locked(); }

            eval { $npc->AddItem($itemid, 1); };
            if ($@) { quest::debug("[2230] Loot add error: $@"); }

            if ($was_invul) { _lock_if_unlocked(); }
        }
    }
}

# -----------------------------------------------------------
# EVENT_DAMAGE — only allow keyholders to damage
# -----------------------------------------------------------
sub EVENT_DAMAGE {
    my ($d,$sid,$cid) = @_;
    return $d unless $npc;

    my $atk = $entity_list->GetMobID($cid);
    return $d unless $atk;
    my $c;

    if ($atk->IsClient()) {
        $c = $atk->CastToClient();
    } elsif ($atk->IsPet()) {
        my $o = $atk->GetOwner();
        $c = $o->CastToClient() if $o && $o->IsClient();
    } elsif ($atk->IsBot()) {
        my $o = $atk->CastToBot()->GetOwner();
        $c = $o->CastToClient() if $o && $o->IsClient();
    }

    if ($c) {
        if (_client_has_key($c)) {
            _unlock_if_locked();
        } else {
            _lock_if_unlocked();
            $npc->WipeHateList();
            return -1;
        }
    }
    return $d;
}

# -----------------------------------------------------------
# EVENT_DEATH_COMPLETE — essence/key progression
# -----------------------------------------------------------
sub EVENT_DEATH_COMPLETE {
    my $c = plugin::GetKillerClient($npc,$entity_list);
    return unless $c;
    my $cid = $c->CharacterID();

    # Mark mini kill
    my $flag = "CONV_F4_Mini2230_${cid}";
    unless (quest::get_data($flag)) {
        quest::set_data($flag,1);
        $c->Message(13,"🔥 You have absorbed the molten essence of the Cinderweb Matron!");
    }

    # Ember Key progression
    my $ess  = quest::get_data("CONV_F4_EssenceCount_${cid}") || 0;
    my $done = quest::get_data("CONV_F4_KeyGiven_${cid}") || 0;
    if ($ess >= 12 && !$done) {
        plugin::GrantKeyIfMissing($c, 57163, "Ember Key", "Floor 5");
        quest::set_data("CONV_F4_KeyGiven_${cid}", 1);
        $c->Message(15,"The air cools as the Ember Key binds to your essence.");
    }

    eval { plugin::HandleEssence($npc,$c); };
}