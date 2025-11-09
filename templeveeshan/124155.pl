# ===========================================================
# #Vulak`Aerr
# Temple of Veeshan — Shadowed Eclipse Final Encounter
# - Applies ToV boss baseline stats
# - Integrates RaidScaling for adaptive raid power
# - Standardized for apex dragon encounters
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;
    $npc->Shout("This ends now!");

    # === Baseline ToV Boss Stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 61);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 13500000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 9000);
    $npc->ModifyNPCStat("max_hit", 11500);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 950);
    $npc->ModifyNPCStat("sta", 950);
    $npc->ModifyNPCStat("agi", 950);
    $npc->ModifyNPCStat("dex", 950);
    $npc->ModifyNPCStat("wis", 950);
    $npc->ModifyNPCStat("int", 950);
    $npc->ModifyNPCStat("cha", 750);

    $npc->ModifyNPCStat("mr", 220);
    $npc->ModifyNPCStat("fr", 220);
    $npc->ModifyNPCStat("cr", 220);
    $npc->ModifyNPCStat("pr", 220);
    $npc->ModifyNPCStat("dr", 220);
    $npc->ModifyNPCStat("corruption_resist", 220);
    $npc->ModifyNPCStat("physical_resist", 550);

    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # === Raid Scaling Integration ===
    plugin::RaidScaling($entity_list, $npc);

    # === Set HP to Max ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("check_back_item", 1);    # Check back slot every second
    } else {
        quest::stoptimer("check_back_item");
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_back_item") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 500; # Adjust if needed
        my $entity_list = $entity_list;

        foreach my $client ($entity_list->GetClientList()) {
            my $distance = $client->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                my $back_item = $client->GetItemIDAt(8); # Slot 8 = Back
                if ($back_item != 30583) {
                    $npc->Shout("Without the protective item, you are obliterated by Vulak's wrath!");
                    $client->BuffFadeAll(); # Strip all buffs
                    $client->Kill();         # Kill player
                }
            }
        }
    }
}