# ===========================================================
# 2214.pl - Tower of Shattered Lanterns (Ashenmaw)
# Mini Boss 1 (Lantern Mini) Essence + Era Loot + Era Stats
# ===========================================================

# --- Era->pool mapping ---
my %ERA_POOLS = (
    A => [600413,600417,600421,600425,600429,600433],
    K => [600412,600416,600420,600424,600428,600432],
    V => [600411,600415,600419,600423,600427,600431],
    L => [600410,600414,600418,600422,600426,600430],
    P => [600434,600435,600436,600437,600438,600439,600440,600441]
);

# --- Era->key mapping ---
my %ERA_KEY = (
    antonica => 'A',
    kunark   => 'K',
    velious  => 'V',
    luclin   => 'L',
    pop      => 'P',
);

# --- Era zoneflags by era ---
my %ERA_ZONES = (
    pop      => [200,204,205],
    luclin   => [459,165,156,153,164,173,179,172,160,170,157,167,175,169,171,162],
    velious  => [110,111,116,121,118,112,117,125,120,123,119,113,127,128,124],
    kunark   => [97,88,92,81,107,79,104,93,105,94,90,85,87,109,84,102,95,89,103,108],
    antonica => [18,39,59,64,66,71,72,74,101,32,73,96,91,11,17,40,41,42],
);

# ===========================================================
# Internal helpers
# ===========================================================
sub _determine_era_including_gm {
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

# ===========================================================
# EVENT_SPAWN — delay loot until era is detected
# ===========================================================
sub EVENT_SPAWN {
    return if !$npc || $npc->IsPet();
    quest::debug("[Ashenmaw] Spawned; starting era seed timer.");
    quest::settimer("seed_loot", 3);
}

# ===========================================================
# EVENT_TIMER — resolve era, apply stats, and seed loot
# ===========================================================
sub EVENT_TIMER {
    if ($timer eq "seed_loot") {
        my @clients = $entity_list->GetClientList();
        if (!@clients) {
            quest::debug("[Ashenmaw] No clients found yet; retrying loot seed.");
            quest::stoptimer("seed_loot");
            quest::settimer("seed_loot", 3);
            return;
        }

        quest::stoptimer("seed_loot");

        my $era = _determine_era_including_gm($entity_list);
        $npc->SetEntityVariable("spawned_era", $era);
        quest::debug("[Ashenmaw] Detected era: $era");

        eval { plugin::ApplyEraStats($npc, $era, 1); };

        my $key = $ERA_KEY{$era} || 'A';
        if ($key && exists $ERA_POOLS{$key}) {
            my @pool = @{$ERA_POOLS{$key}};
            my $itemid = $pool[int(rand(@pool))];
            eval { $npc->AddItem($itemid); };
            $npc->SetEntityVariable("seeded_item_2214", $itemid);
            quest::debug("[Ashenmaw] Seeded random loot itemID=$itemid");
        }
    }

    # --- delayed cursed check ---
    if ($timer eq "ash_cursed_delay") {
        quest::stoptimer("ash_cursed_delay");
        quest::debug("[Ashenmaw] ash_cursed_delay timer fired; scanning for clients.");

        my $attacker = $npc->GetHateTop();
        my $client;

        if ($attacker) {
            if ($attacker->IsClient()) {
                $client = $attacker->CastToClient();
                quest::debug("[Ashenmaw] Found top hate client: " . $client->GetCleanName());
            } elsif ($attacker->IsPet()) {
                my $owner = $attacker->GetOwner();
                if ($owner && $owner->IsClient()) {
                    $client = $owner->CastToClient();
                    quest::debug("[Ashenmaw] Top hate is pet; resolved owner: " . $client->GetCleanName());
                }
            } elsif ($attacker->IsBot()) {
                my $owner = $attacker->CastToBot()->GetOwner();
                if ($owner && $owner->IsClient()) {
                    $client = $owner->CastToClient();
                    quest::debug("[Ashenmaw] Top hate is bot; resolved owner: " . $client->GetCleanName());
                }
            }
        }

        # nearby fallback
        if (!$client) {
            foreach my $c ($entity_list->GetClientList()) {
                next unless $c && !$c->GetGM();
                next if $npc->CalculateDistance($c->GetX(), $c->GetY(), $c->GetZ()) > 200;
                $client = $c;
                quest::debug("[Ashenmaw] Using nearby client fallback: " . $client->GetCleanName());
                last;
            }
        }

        # final fail-safe
        if (!$client) {
            my @clients = $entity_list->GetClientList();
            if (@clients) {
                $client = $clients[0];
                quest::debug("[Ashenmaw] Using final fail-safe client: " . $client->GetCleanName());
            }
        }

        if ($client && !$npc->GetEntityVariable("cursed_seeded")) {
            quest::debug("[Ashenmaw] Triggering cursed check for " . $client->GetCleanName());
            plugin::CheckForCursedItemsAndSeedLoot($npc, $client);
            $npc->SetEntityVariable("cursed_seeded", 1);
        } else {
            quest::debug("[Ashenmaw] No valid client found or already seeded.");
        }
    }
}

# ===========================================================
# EVENT_COMBAT — start delayed cursed check
# ===========================================================
sub EVENT_COMBAT {
    return unless $npc;

    # USE THE GLOBAL $combat_state — DO NOT 'shift'
    quest::debug("[Ashenmaw] EVENT_COMBAT triggered: state=$combat_state");

    if ($combat_state == 1) {
        # let hate list stabilize (pets/bots -> owners) before we check
        quest::settimer("ash_cursed_delay", 2);
    } else {
        quest::debug("[Ashenmaw] Combat ended; stopping cursed delay timer.");
        quest::stoptimer("ash_cursed_delay");
    }
}

# ===========================================================
# EVENT_DEATH_COMPLETE — handle essence credit
# ===========================================================
sub EVENT_DEATH_COMPLETE {
    return if !$npc;
    my $client = plugin::GetKillerClient($npc, $entity_list);
    return unless $client;

    my $cid  = $client->CharacterID();
    my $mkey = "CONV_F1_Mini2214_${cid}";
    my $done = quest::get_data($mkey) || 0;

    if (!$done) {
        quest::set_data($mkey, 1);
        $client->Message(13, "✨ You have absorbed the essence of Mini Boss 2214!");
        quest::debug("[Ashenmaw] Essence credit granted for " . $client->GetCleanName());
    }

    eval { plugin::HandleEssence($npc, $client); };
    quest::debug("[Ashenmaw] Death complete handled.");
}