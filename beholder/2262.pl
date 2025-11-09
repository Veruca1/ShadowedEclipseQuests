# ==========================================
# Featherblight the Gluttonous - Thanksgiving Event Boss
# NPCID: 2262
# HP events at 80/60/40/20% spawn 10 adds
# Era detection + ApplyEraStats + PoP era stat boost
# Era-based loot seeded on combat begin
# ==========================================

# --- Era loot pools ---
my %ERA_POOLS = (
    pop      => [66906,66904,66907,66908,66909],  # Gravyboat, Powercore, Chainmail, Talisman, Drumstick
    luclin   => [600450,600458,600442,600446,600454],
    velious  => [600455,600447,600443,600459,600451],
    kunark   => [600452,600460,600444,600448,600456],
    antonica => [600457,600449,600445,600461,600453],  # Hate equivalent
);

# --- Era zoneflags by era ---
my %ERA_ZONES = (
    pop      => [200,204,205],
    luclin   => [459,165,156,153,164,173,179,172,160,170,157,167,175,169,171,162],
    velious  => [110,111,116,121,118,112,117,125,120,123,119,113,127,128,124],
    kunark   => [97,88,92,81,107,79,104,93,105,94,90,85,87,109,84,102,95,89,103,108],
    antonica => [18,39,59,64,66,71,72,74,101,32,73,96,91,11,17,40,41,42],
);

# --- Helper: Determine Era from clients in zone ---
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
    quest::setnexthpevent(80);
    quest::settimer("detect_era", 3);
}

# ===========================================================
# EVENT_TIMER — Era detection + PoP boost
# ===========================================================
sub EVENT_TIMER {
    if ($timer eq "detect_era") {
        quest::stoptimer("detect_era");

        my $era = _determine_era($entity_list);
        $npc->SetEntityVariable("spawned_era", $era);

        #quest::debug("[Featherblight] Detected era: $era");
        quest::shout("Featherblight senses the winds of the $era era!");

        # Apply base era stats (boss tier)
        eval { plugin::ApplyEraStats($npc, $era, 1); };
        if ($@) {
            #quest::debug("[Featherblight] ApplyEraStats failed: $@");
        } else {
            #quest::debug("[Featherblight] ApplyEraStats applied for era: $era");
        }

        # PoP Era Bonus
        if ($era eq "pop") {
            my $current_hp  = $npc->GetMaxHP();
            my $current_min = $npc->GetMinDMG();
            my $current_max = $npc->GetMaxDMG();

            my $new_hp  = $current_hp + 125000000;
            my $new_min = int($current_min * 1.25);
            my $new_max = int($current_max * 1.25);

            $npc->ModifyNPCStat("max_hp", $new_hp);
            $npc->SetHP($npc->GetMaxHP());
            $npc->ModifyNPCStat("min_hit", $new_min);
            $npc->ModifyNPCStat("max_hit", $new_max);

            #quest::debug("[Featherblight] PoP bonus: +125m HP, +25% damage.");
            quest::shout("Featherblight grows stronger under the Planes of Power!");
        }
    }

    if ($timer eq "seed_loot") {
        quest::stoptimer("seed_loot");
        my $era = $npc->GetEntityVariable("spawned_era") || "antonica";

        if (exists $ERA_POOLS{$era}) {
            my @pool = @{$ERA_POOLS{$era}};
            my $itemid = $pool[int(rand(@pool))];
            eval { $npc->AddItem($itemid); };
            $npc->SetEntityVariable("seeded_item_2262", $itemid);
            #quest::debug("[Featherblight] Loot seeded for era '$era': itemid=$itemid");
        } else {
            #quest::debug("[Featherblight] No valid loot pool found for era '$era'");
        }
    }
}

# ===========================================================
# EVENT_COMBAT — Start loot seeding on combat
# ===========================================================
sub EVENT_COMBAT {
    return unless $npc;
    #quest::debug("[Featherblight] EVENT_COMBAT triggered: state=$combat_state");

    if ($combat_state == 1) {
        quest::settimer("seed_loot", 3); # seed loot shortly after combat starts
    } else {
        quest::stoptimer("seed_loot");
    }
}

# ===========================================================
# HP Events - Spawn Adds
# ===========================================================
sub EVENT_HP {
    my $hp_event = $hpevent;

    if ($hp_event == 80) {
        spawn_turkey_adds();
        quest::setnexthpevent(60);
    }
    elsif ($hp_event == 60) {
        spawn_turkey_adds();
        quest::setnexthpevent(40);
    }
    elsif ($hp_event == 40) {
        spawn_turkey_adds();
        quest::setnexthpevent(20);
    }
    elsif ($hp_event == 20) {
        spawn_turkey_adds();
    }
}

sub spawn_turkey_adds {
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();

    quest::emote("lets out a thunderous gobble as turkey reinforcements storm the stage!");

    for (my $i = 0; $i < 10; $i++) {
        my $mob_to_spawn = (int(rand(2)) == 0) ? 2263 : 2264; # destroyer or clucker
        my $offset_x = quest::ChooseRandom(-20..20);
        my $offset_y = quest::ChooseRandom(-20..20);

        quest::spawn2($mob_to_spawn, 0, 0, $x + $offset_x, $y + $offset_y, $z, $h);
    }
}