# ===========================================================
# Tower of Shattered Lanterns – Floor 2 Trash Logic
# (Used for NPCs 2216–2218)
# ===========================================================
#  • Default: Invulnerable
#  • Unlocks when a nearby player has Tower Key (56755)
#  • Once killed, grants Floor 2 essence progress (max 12)
#  • Calls plugin::HandleEssence() to manage Obsidian Key unlock
# ===========================================================

my $TOWER_KEY_ID   = 56755;   # Floor 1 → 2 key
my $CHECK_RADIUS   = 250;
my $CHECK_INTERVAL = 5;

# ------------------------------
# Helper – Key checks
# ------------------------------
sub _has_tower_key_inventory {
    my ($client) = @_;
    return 0 unless $client && $client->IsClient();
    return ($client->CountItem($TOWER_KEY_ID) > 0) ? 1 : 0;
}

sub _has_tower_key_keyring {
    my ($client) = @_;
    return 0 unless $client && $client->IsClient();
    return ($client->KeyRingCheck($TOWER_KEY_ID)) ? 1 : 0;
}

sub _client_has_key_anywhere {
    my ($client) = @_;
    return 0 unless $client && $client->IsClient();
    return (_has_tower_key_inventory($client) || _has_tower_key_keyring($client));
}

sub _any_keyholder_nearby {
    my ($npc_ref, $radius) = @_;
    return 0 unless $npc_ref && $npc_ref->IsNPC();
    foreach my $c ($entity_list->GetClientList()) {
        next unless $c && $c->IsClient();
        next if $npc_ref->CalculateDistance($c->GetX(), $c->GetY(), $c->GetZ()) > $radius;
        return 1 if _client_has_key_anywhere($c);
    }
    return 0;
}

# ------------------------------
# Helper – Lock / Unlock
# ------------------------------
sub _unlock_if_locked {
    return unless $npc;
    if ($npc->GetInvul()) {
        $npc->SetInvul(0);
        foreach my $sa (19,20,22,23,24,25,35,39) { $npc->SetSpecialAbility($sa, 0); }
    }
}

sub _lock_if_unlocked {
    return unless $npc;
    if (!$npc->GetInvul()) {
        $npc->SetInvul(1);
        foreach my $sa (19,20,22,23,24,25,35,39) { $npc->SetSpecialAbility($sa, 1); }
    }
}

# ------------------------------
# EVENT_SPAWN
# ------------------------------
sub EVENT_SPAWN {
    return unless $npc;
    $npc->SetInvul(1);
    foreach my $sa (19,20,22,23,24,25,35,39) { $npc->SetSpecialAbility($sa, 1); }
    quest::settimer("f2_keycheck", $CHECK_INTERVAL);
}

# ------------------------------
# EVENT_TIMER – Periodic Key Check
# ------------------------------
sub EVENT_TIMER {
    return unless $npc;
    if ($_[0] eq "f2_keycheck") {
        if (_any_keyholder_nearby($npc, $CHECK_RADIUS)) { _unlock_if_locked(); }
        else { _lock_if_unlocked(); }
    }
}

# ------------------------------
# EVENT_DAMAGE – Realtime Unlock Check
# ------------------------------
sub EVENT_DAMAGE {
    my ($damage, $spell_id, $caster_id) = @_;
    my $attacker = $entity_list->GetMobID($caster_id);
    return $damage unless $attacker && $npc;

    my $client;
    if ($attacker->IsClient()) {
        $client = $attacker->CastToClient();
    } elsif ($attacker->IsPet()) {
        my $o = $attacker->GetOwner(); $client = $o->CastToClient() if $o && $o->IsClient();
    } elsif ($attacker->IsBot()) {
        my $o = $attacker->CastToBot()->GetOwner(); $client = $o->CastToClient() if $o && $o->IsClient();
    }

    if ($client) {
        if (_client_has_key_anywhere($client)) {
            _unlock_if_locked();
            return $damage;
        } else {
            _lock_if_unlocked();
            $npc->WipeHateList();
            return -1;
        }
    }
    return $damage;
}

# ------------------------------
# EVENT_COMBAT – Aggro Control
# ------------------------------
sub EVENT_COMBAT {
    if ($combat_state == 1 && $npc) {
        if (_any_keyholder_nearby($npc, $CHECK_RADIUS)) { _unlock_if_locked(); }
        else { _lock_if_unlocked(); $npc->WipeHateList(); }
    }
}

# ------------------------------
# EVENT_DEATH_COMPLETE – Essence Logic
# ------------------------------
sub EVENT_DEATH_COMPLETE {
    return unless $npc && !$npc->IsPet();
    my $client = plugin::GetKillerClient($npc, $entity_list);
    unless ($client) {
        return;
    }

    my $cid   = $client->CharacterID();
    my $name  = $client->GetCleanName();
    my $mob   = $npc->GetCleanName();
    my $ess   = "CONV_F2_EssenceCount_${cid}";
    my $count = quest::get_data($ess) || 0;

    if ($count < 12) {
        $count++;
        quest::set_data($ess, $count);
        $client->Message(15, "You have gathered an essence of Floor 2 [$count/12]");
    }

    # ✅ Check for Obsidian Key unlock conditions
    plugin::HandleEssence($npc, $client);
}