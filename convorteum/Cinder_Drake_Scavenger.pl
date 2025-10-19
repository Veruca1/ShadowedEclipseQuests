# ===========================================================
# Floor 4 Trash - Tower of Shattered Lanterns
# NPC Example: 2226 (Cinder_Drake_Scavenger)
# -----------------------------------------------------------
# • Invulnerable until a nearby player has the Phantasmal Key (57162)
# • Grants Floor 4 Essence progress (12 max)
# • Triggers plugin::HandleEssence → Umbral Key (57164)
# ===========================================================

my $TOWER_KEY_ID   = 57162;   # Phantasmal Key (Floor 3 → 4)
my $CHECK_RADIUS   = 250;
my $CHECK_INTERVAL = 5;

# ------------------------------
# Key check helpers
# ------------------------------
sub _has_tower_key_inventory {
    my ($client) = @_;
    return 0 unless $client && $client->IsClient();
    my $count = $client->CountItem($TOWER_KEY_ID);
    return ($count && $count > 0) ? 1 : 0;
}

sub _has_tower_key_keyring {
    my ($client) = @_;
    return 0 unless $client && $client->IsClient();
    my $kr = 0;
    eval { $kr = $client->KeyRingCheck($TOWER_KEY_ID) ? 1 : 0; };
    return $kr ? 1 : 0;
}

sub _client_has_key_anywhere {
    my ($client) = @_;
    return 0 unless $client && $client->IsClient();
    return (_has_tower_key_inventory($client) || _has_tower_key_keyring($client)) ? 1 : 0;
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
# Lock / Unlock logic
# ------------------------------
sub _unlock_if_locked {
    return unless $npc;
    if ($npc->GetInvul()) {
        $npc->SetInvul(0);
        $npc->SetSpecialAbility($_, 0) for (19,20,22,23,24,25,35,39);
    }
}

sub _lock_if_unlocked {
    return unless $npc;
    if (!$npc->GetInvul()) {
        $npc->SetInvul(1);
        $npc->SetSpecialAbility($_, 1) for (19,20,22,23,24,25,35,39);
    }
}

# ------------------------------
# Events – Spawn / Timer / Damage / Combat
# ------------------------------
sub EVENT_SPAWN {
    return unless $npc;
    $npc->SetInvul(1);
    $npc->SetSpecialAbility($_, 1) for (19,20,22,23,24,25,35,39);
    quest::settimer("f4_keycheck", $CHECK_INTERVAL);
}

sub EVENT_TIMER {
    return unless $npc;
    if ($_[0] eq "f4_keycheck") {
        if (_any_keyholder_nearby($npc, $CHECK_RADIUS)) { _unlock_if_locked(); }
        else { _lock_if_unlocked(); }
    }
}

sub EVENT_DAMAGE {
    my ($damage, $spell_id, $caster_id) = @_;
    return $damage unless $npc;

    my $attacker = $entity_list->GetMobID($caster_id);
    return $damage unless $attacker;

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
            # Optionally, you could send a private message:
            # $client->Message(13, "Your attacks are repelled by an unseen barrier!");
            return -1;
        }
    }
    return $damage;
}

sub EVENT_COMBAT {
    if ($combat_state == 1 && $npc) {
        if (_any_keyholder_nearby($npc, $CHECK_RADIUS)) { _unlock_if_locked(); }
        else { _lock_if_unlocked(); $npc->WipeHateList(); }
    }
}

# ------------------------------
# EVENT_DEATH_COMPLETE – Essence Logic (Floor 4)
# ------------------------------
sub EVENT_DEATH_COMPLETE {
    return unless $npc && !$npc->IsPet();

    my $client = plugin::GetKillerClient($npc, $entity_list);
    return unless $client;

    my $cid   = $client->CharacterID();
    my $ess   = "CONV_F4_EssenceCount_${cid}";
    my $count = quest::get_data($ess) || 0;

    if ($count < 12) {
        $count++;
        quest::set_data($ess, $count);
        $client->Message(15, "You have gathered an essence of Floor 4 [$count/12]");
    }

    plugin::HandleEssence($npc, $client);
}