# ===========================================================
# 2219.pl – Tower of Shattered Lanterns
# Floor 2 Mini Boss (Obsidian Widow)
# -----------------------------------------------------------
# • Invulnerable until a nearby player has Tower Key (56755)
# • Full combat suppression until unlocked
# • 50% chance to drop era loot on first combat engage
# • Grants Floor 2 mini essence on death and calls HandleEssence
# ===========================================================

my $TOWER_KEY_ID   = 56755;   # Tower Key (F1→F2)
my $CHECK_RADIUS   = 250;
my $CHECK_INTERVAL = 5;
my $LOOT_SEEDED    = 0;       # ensure loot seeds only once

# -----------------------------------------------------------
# Keyholder / invulnerability helpers
# -----------------------------------------------------------
sub _has_key_inv   { my($c)=@_; return ($c && $c->IsClient() && $c->CountItem($TOWER_KEY_ID) > 0) ? 1 : 0; }
sub _has_key_ring  { my($c)=@_; return 0 unless $c && $c->IsClient(); my $ok=0; eval{ $ok=$c->KeyRingCheck($TOWER_KEY_ID)?1:0; }; return $ok; }
sub _client_has_key{ my($c)=@_; return (_has_key_inv($c)||_has_key_ring($c)); }

sub _any_keyholder_nearby {
    my ($npc_ref,$r)=@_;
    return 0 unless $npc_ref;
    foreach my $c ($entity_list->GetClientList()) {
        next unless $c->IsClient();
        next if $npc_ref->CalculateDistance($c->GetX,$c->GetY,$c->GetZ) > $r;
        return 1 if _client_has_key($c);
    }
    return 0;
}

sub _unlock_if_locked { return unless $npc && $npc->GetInvul(); $npc->SetInvul(0); $npc->SetSpecialAbility($_,0) for (19,20,22,23,24,25,35,39); }
sub _lock_if_unlocked { return unless $npc && !$npc->GetInvul(); $npc->SetInvul(1); $npc->SetSpecialAbility($_,1) for (19,20,22,23,24,25,35,39); }

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
    my ($elist)=@_;
    my $detected="antonica";
    my @clients=$elist->GetClientList();
    foreach my $c (@clients){
        next unless $c && $c->IsClient();
        my $era=plugin::DetermineEraForClient($c);
        if($era){ $detected=$era; last; }
    }
    return $detected;
}

# -----------------------------------------------------------
# EVENT_SPAWN
# -----------------------------------------------------------
sub EVENT_SPAWN {
    return unless $npc;
    _lock_if_unlocked();
    quest::settimer("f2_keycheck",$CHECK_INTERVAL);
}

# -----------------------------------------------------------
# EVENT_TIMER
# -----------------------------------------------------------
sub EVENT_TIMER {
    return unless $npc;
    if ($_[0] eq "f2_keycheck") {
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
            # Prevent duplicate seeding
            unless ($npc->GetEntityVariable("cursed_seeded")) {
                plugin::CheckForCursedItemsAndSeedLoot($npc, $attacker);
                $npc->SetEntityVariable("cursed_seeded", 1);
            }
        }

        # 50% chance to drop loot
        my $roll = int(rand(100));
        return if $roll >= 50;

        # Determine era dynamically
        my $era = _determine_era_including_gm($entity_list);
        my $key = $ERA_KEY{$era} || 'A';

        if (exists $ERA_POOLS{$key}) {
            my @pool = @{$ERA_POOLS{$key}};
            my $itemid = $pool[int(rand(@pool))];

            my $was_invul = $npc->GetInvul();
            if ($was_invul) { _unlock_if_locked(); }

            eval { $npc->AddItem($itemid, 1); };

            if ($was_invul) { _lock_if_unlocked(); }
        }
    }
}

# -----------------------------------------------------------
# EVENT_DAMAGE
# -----------------------------------------------------------
sub EVENT_DAMAGE {
    my($d,$sid,$cid)=@_; return $d unless $npc;
    my $atk=$entity_list->GetMobID($cid); return $d unless $atk;
    my $c;
    if($atk->IsClient()){ $c=$atk->CastToClient(); }
    elsif($atk->IsPet()){ my $o=$atk->GetOwner(); $c=$o->CastToClient() if $o && $o->IsClient(); }
    elsif($atk->IsBot()){ my $o=$atk->CastToBot()->GetOwner(); $c=$o->CastToClient() if $o && $o->IsClient(); }
    if($c){ if(_client_has_key($c)){ _unlock_if_locked(); } else { _lock_if_unlocked(); $npc->WipeHateList(); return -1; } }
    return $d;
}

# -----------------------------------------------------------
# EVENT_DEATH_COMPLETE – Mini Essence + Plugin Call
# -----------------------------------------------------------
sub EVENT_DEATH_COMPLETE {
    return unless $npc && !$npc->IsPet();

    my $client = plugin::GetKillerClient($npc, $entity_list);
    return unless $client;

    my $cid = $client->CharacterID();
    my $flag = "CONV_F2_Mini2219_${cid}";

    unless (quest::get_data($flag)) {
        quest::set_data($flag,1);
        $client->Message(13,"✨ You have absorbed the essence of the Obsidian Widow!");
    }

    # Check for Obsidian Key unlock progression
    eval { plugin::HandleEssence($npc,$client); };
}