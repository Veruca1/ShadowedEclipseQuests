# ===========================================================
# 2247.pl – Obsidian_Plinth (Tower Trigger)
# -----------------------------------------------------------
# • Spawns invulnerable with all blocking abilities
# • Era-scaled stats + faction normalization
# • If it receives signal 10 → becomes vulnerable
# • On death → sends signal 2 to 2242 (Morghast unlock)
# ===========================================================

sub _lock_invul {
    return unless $npc;
    $npc->SetInvul(1);
    $npc->SetSpecialAbility($_, 1) for (19,20,22,23,24,25,35,39);
}

sub _unlock_vul {
    return unless $npc;
    $npc->SetInvul(0);
    $npc->SetSpecialAbility($_, 0) for (19,20,22,23,24,25,35,39);
    quest::ze(15, "The Obsidian Plinth vibrates violently as cracks form along its surface!");
}

# ===========================================================
# Era scaling (safe version)
# ===========================================================
sub _determine_era {
    my %eras = (
        antonica => [18,39,59,64,66,71,72,74,101,32,73,96,91,11,17,40,41,42],
        kunark   => [97,88,92,81,107,79,104,93,105,94,90,85,87,109,84,102,95,89,103,108],
        velious  => [110,111,116,121,118,112,117,125,120,123,119,113,127,128,124],
        luclin   => [459,165,156,153,164,173,179,172,160,170,157,167,175,169,171,162],
        pop      => [200,204,205],
    );

    foreach my $era (qw(pop luclin velious kunark antonica)) {
        my @clients = $entity_list->GetClientList();
        foreach my $c (@clients) {
            next unless $c && $c->IsClient();
            foreach my $zid (@{$eras{$era}}) {
                return $era if $c->HasZoneFlag($zid);
            }
        }
    }
    return "antonica";
}

sub _scale_self_once {
    return if $npc->GetEntityVariable("scaled");
    my $inst_id = quest::GetInstanceID("convorteum", 1);
    eval { plugin::ResetEraCache(); };
    my $era = $qglobals{"era_" . $inst_id} || _determine_era();
    eval { plugin::ApplyEraStats($npc, $era, 0); };
    eval { plugin::RaidScaling($entity_list, $npc); };
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("npc_faction_id", 623);
    $npc->SetEntityVariable("scaled", 1);
}

# ===========================================================
# Events
# ===========================================================
sub EVENT_SPAWN {
    _scale_self_once();
    _lock_invul();
    quest::debug("[2247] Spawned invulnerable, era-scaled Obsidian Plinth.");
}

sub EVENT_SIGNAL {
    my $sig = $signal;
    _unlock_vul() if $sig == 10;
}

sub EVENT_DEATH_COMPLETE {
    quest::ze(15, "The Obsidian Plinth collapses into shards of black glass – another ward around Morghast is broken!");
    quest::signalwith(2242, 2);
}