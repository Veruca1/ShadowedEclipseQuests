# ===========================================================
# 2243.pl – Ascent_Plinth (Tower Trigger)
# -----------------------------------------------------------
# • Spawns invulnerable with all blocking abilities
# • Performs era + raid scaling on spawn
# • If it receives signal 10 → becomes vulnerable (attackable)
# • On death → sends signal 1 to 2242 (Morghast unlock)
# ===========================================================

sub _lock_invul {
    return unless $npc;
    $npc->SetInvul(1);
    $npc->SetSpecialAbility($_, 1) for (19,20,22,23,24,25,35,39);
    quest::debug("[2243] Locked (invulnerable).");
}

sub _unlock_vul {
    return unless $npc;
    $npc->SetInvul(0);
    $npc->SetSpecialAbility($_, 0) for (19,20,22,23,24,25,35,39);
    quest::ze(15, "The Ascent Plinth hums to life, its defenses falter!");
    quest::debug("[2243] Unlocked (vulnerable).");
}

# ===========================================================
# Era + Raid Scaling
# ===========================================================
sub _mark_scaled { $npc->SetEntityVariable("se_scaled","1"); }
sub _was_scaled  { return ($npc->GetEntityVariable("se_scaled")||"") eq "1"; }

sub _determine_era_including_gm {
    my %eras = (
        antonica => [18,39,59,64,66,71,72,74,101,32,73,96,91,11,17,40,41,42],
        kunark   => [97,88,92,81,107,79,104,93,105,94,90,85,87,109,84,102,95,89,103,108],
        velious  => [110,111,116,121,118,112,117,125,120,123,119,113,127,128,124],
        luclin   => [459,165,156,153,164,173,179,172,160,170,157,167,175,169,171,162],
        pop      => [200,204,205],
    );
    my @clients = $entity_list->GetClientList();
    foreach my $era (qw(pop luclin velious kunark antonica)) {
        foreach my $c (@clients) {
            next unless $c && $c->IsClient();
            foreach my $zoneid (@{$eras{$era}}) {
                return $era if $c->HasZoneFlag($zoneid);
            }
        }
    }
    return "antonica";
}

sub _apply_era_scaling {
    return if _was_scaled();

    my @clients = $entity_list->GetClientList();
    if (!@clients) {
        quest::settimer("retry_scale", 3);
        return;
    }

    my $inst_id = quest::GetInstanceID("convorteum", 1);
    eval { plugin::ResetEraCache(); };

    my $era = $qglobals{"era_" . $inst_id};
    $era = _determine_era_including_gm() unless $era;

    eval { plugin::ApplyEraStats($npc, $era, 0); };   # not a boss
    eval { plugin::RaidScaling($entity_list, $npc); };

    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("npc_faction_id", 623);

    _mark_scaled();
    quest::debug("[2243] Era scaling applied for '$era'.");
}

# ===========================================================
# Events
# ===========================================================
sub EVENT_SPAWN {
    _apply_era_scaling();
    _lock_invul();
    quest::debug("[2243] Spawned invulnerable plinth (scaled), awaiting signal 10.");
}

sub EVENT_TIMER {
    if ($_[0] eq "retry_scale") {
        quest::stoptimer("retry_scale");
        _apply_era_scaling();
    }
}

sub EVENT_SIGNAL {
    my $sig = $signal;
    _unlock_vul() if $sig == 10;
}

sub EVENT_DEATH_COMPLETE {
    quest::ze(15, "The Ascent Plinth shatters with a pulse of energy – the wards around Morghast weaken!");
    quest::signalwith(2242, 1);
    quest::debug("[2243] Sent signal 1 to 2242 (boss unlock).");
}