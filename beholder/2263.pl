# ==========================================
# a_cornfed_destroyer - Featherblight Add
# NPCID: 2263
# Era detection + ApplyEraStats (trash tier)
# Antonica debuff (-50%) | PoP buff (+125m HP, +25% damage)
# ==========================================

my %ERA_ZONES = (
    pop      => [200,204,205],
    luclin   => [459,165,156,153,164,173,179,172,160,170,157,167,175,169,171,162],
    velious  => [110,111,116,121,118,112,117,125,120,123,119,113,127,128,124],
    kunark   => [97,88,92,81,107,79,104,93,105,94,90,85,87,109,84,102,95,89,103,108],
    antonica => [18,39,59,64,66,71,72,74,101,32,73,96,91,11,17,40,41,42],
);

sub _determine_era {
    my ($elist) = @_;
    my @clients = $elist->GetClientList();
    return "antonica" unless @clients;
    foreach my $c (@clients) {
        next unless $c && $c->IsClient();
        foreach my $era (qw(pop luclin velious kunark antonica)) {
            foreach my $zoneid (@{$ERA_ZONES{$era}}) {
                return $era if $c->HasZoneFlag($zoneid);
            }
        }
    }
    return "antonica";
}

sub EVENT_SPAWN {
    quest::settimer("detect_era", 2);
}

sub EVENT_TIMER {
    if ($timer eq "detect_era") {
        quest::stoptimer("detect_era");

        my $era = _determine_era($entity_list);
        $npc->SetEntityVariable("spawned_era", $era);
        quest::debug("[Cornfed Destroyer] Detected era: $era");

        eval { plugin::ApplyEraStats($npc, $era, 0); };  # Trash mob
        if ($@) {
            quest::debug("[Cornfed Destroyer] ApplyEraStats failed: $@");
        } else {
            quest::debug("[Cornfed Destroyer] ApplyEraStats applied (trash tier).");
        }

        my $current_hp  = $npc->GetMaxHP();
        my $current_min = $npc->GetMinDMG();
        my $current_max = $npc->GetMaxDMG();

        if ($era eq "antonica") {
            my $new_hp  = int($current_hp * 0.5);
            my $new_min = int($current_min * 0.5);
            my $new_max = int($current_max * 0.5);

            $npc->ModifyNPCStat("max_hp", $new_hp);
            $npc->SetHP($npc->GetMaxHP());
            $npc->ModifyNPCStat("min_hit", $new_min);
            $npc->ModifyNPCStat("max_hit", $new_max);

            quest::debug("[Cornfed Destroyer] Antonica debuff: -50% HP/damage.");
        }

        if ($era eq "pop") {
            my $new_hp  = $current_hp + 1250000;
            my $new_min = int($current_min * 1.25);
            my $new_max = int($current_max * 1.25);

            $npc->ModifyNPCStat("max_hp", $new_hp);
            $npc->SetHP($npc->GetMaxHP());
            $npc->ModifyNPCStat("min_hit", $new_min);
            $npc->ModifyNPCStat("max_hit", $new_max);

            #quest::debug("[Cornfed Destroyer] PoP buff: +125m HP and +25% damage.");
        }
    }
}