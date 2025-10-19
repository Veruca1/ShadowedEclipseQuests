# ===========================================================
# 2219.pl – Tower of Shattered Lanterns
# Floor 2 Mini Boss (Obsidian Widow)
# -----------------------------------------------------------
# • Invulnerable until a nearby player has Tower Key (56755)
# • Full combat suppression until unlocked
# • Grants Floor 2 mini essence on death
# • Calls plugin::HandleEssence for Obsidian Key unlock
# ===========================================================

my $TOWER_KEY_ID   = 56755;
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

    my $has_inv = _has_tower_key_inventory($client);
    my $has_kr  = _has_tower_key_keyring($client);
    return ($has_inv || $has_kr) ? 1 : 0;
}

sub _any_keyholder_nearby {
    my ($npc_ref, $radius) = @_;
    return 0 unless $npc_ref && $npc_ref->IsNPC();

    foreach my $c ($entity_list->GetClientList()) {
        next unless $c && $c->IsClient();
        my $dist = $npc_ref->CalculateDistance($c->GetX(), $c->GetY(), $c->GetZ());
        next if $dist > $radius;
        if (_client_has_key_anywhere($c)) {
            return 1;
        }
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
    quest::settimer("f2_keycheck", $CHECK_INTERVAL);
}

sub EVENT_TIMER {
    return unless $npc;
    if ($_[0] eq "f2_keycheck") {
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
# EVENT_DEATH_COMPLETE – Mini Essence + Plugin Call
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
    my $mini  = "CONV_F2_Mini2219_${cid}";
    my $done  = quest::get_data($mini) || 0;

    if (!$done) {
        quest::set_data($mini, 1);
        $client->Message(13, "✨ You have absorbed the essence of the Obsidian Widow!");
    }

    # ✅ Check for Obsidian Key unlock conditions
    plugin::HandleEssence($npc, $client);
}