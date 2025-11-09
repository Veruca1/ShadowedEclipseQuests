# ===========================================================
# Jaled_Dar-s_shade
# Shadowed Eclipse — Necropolis Boss Scaling
# - Applies boss baseline stats
# - Uses RaidScaling for adaptive group power adjustment
# - No optional mechanics
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Start Aggro Timer (as provided) ===
    quest::settimer("aggro_tank", 1);

    # === Boss Baseline Stats (from Necropolis default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 25000);
    $npc->ModifyNPCStat("max_hp", 1750000);
    $npc->ModifyNPCStat("hp_regen", 3200);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 9800);
    $npc->ModifyNPCStat("max_hit", 13000);
    $npc->ModifyNPCStat("atk", 1450);
    $npc->ModifyNPCStat("accuracy", 1220);
    $npc->ModifyNPCStat("avoidance", 55);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 10);
    $npc->ModifyNPCStat("slow_mitigation", 85);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # === Core Attributes ===
    $npc->ModifyNPCStat("str", 1150);
    $npc->ModifyNPCStat("sta", 1150);
    $npc->ModifyNPCStat("agi", 1150);
    $npc->ModifyNPCStat("dex", 1150);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 850);

    # === Resistances ===
    $npc->ModifyNPCStat("mr", 280);
    $npc->ModifyNPCStat("fr", 280);
    $npc->ModifyNPCStat("cr", 280);
    $npc->ModifyNPCStat("pr", 280);
    $npc->ModifyNPCStat("dr", 280);
    $npc->ModifyNPCStat("corruption_resist", 260);
    $npc->ModifyNPCStat("physical_resist", 675);

    # === Special Abilities ===
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^12,1");

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === Reset HP to Full ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_TIMER {
    if ($timer eq "aggro_tank") {
        my $closest_tank;
        my $closest_dist = 99999;

        # Clients
        foreach my $client ($entity_list->GetClientList()) {
            next unless $client;
            my $class = $client->GetClass();
            next unless $class == 1 || $class == 3 || $class == 5;

            my $dist = $npc->CalculateDistance($client);
            if ($dist < $closest_dist) {
                $closest_dist = $dist;
                $closest_tank = $client;
            }
        }

        # Bots
        foreach my $bot ($entity_list->GetBotList()) {
            next unless $bot;
            my $class = $bot->GetClass();
            next unless $class == 1 || $class == 3 || $class == 5;

            my $dist = $npc->CalculateDistance($bot);
            if ($dist < $closest_dist) {
                $closest_dist = $dist;
                $closest_tank = $bot;
            }
        }

        if ($closest_tank) {
            $npc->AddToHateList($closest_tank, 10000);
        }

        quest::stoptimer("aggro_tank");
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 4);
}