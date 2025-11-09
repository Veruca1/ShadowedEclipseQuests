# ===========================================================
# 1771.pl — The_Evasiveness_of_Frostbane (Kael Drakkel)
# Shadowed Eclipse: Velious Tier Boss Scaling
# - Applies Kael baseline boss stats
# - Integrates adaptive RaidScaling system
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Baseline Boss Stats (Kael Default) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 25000);
    $npc->ModifyNPCStat("max_hp", 2000000);
    $npc->ModifyNPCStat("hp_regen", 3000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 9500);
    $npc->ModifyNPCStat("max_hit", 12500);
    $npc->ModifyNPCStat("atk", 1400);
    $npc->ModifyNPCStat("accuracy", 1200);
    $npc->ModifyNPCStat("avoidance", 55);
    $npc->ModifyNPCStat("heroic_strikethrough", 10);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 85);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1100);
    $npc->ModifyNPCStat("sta", 1100);
    $npc->ModifyNPCStat("agi", 1100);
    $npc->ModifyNPCStat("dex", 1100);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 850);

    $npc->ModifyNPCStat("mr", 260);
    $npc->ModifyNPCStat("fr", 260);
    $npc->ModifyNPCStat("cr", 260);
    $npc->ModifyNPCStat("pr", 260);
    $npc->ModifyNPCStat("dr", 260);
    $npc->ModifyNPCStat("corruption_resist", 260);
    $npc->ModifyNPCStat("physical_resist", 650);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^12,1");

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === Set HP to Max after Scaling ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Timers ===
    quest::settimer("frostbabe_shift", 8);  # Timer for shifting between locations every 8 seconds
    quest::settimer("life_drain", 5);       # Timer for life drain every 5 seconds
}

sub EVENT_TIMER {
    if ($timer eq "frostbabe_shift") {
        # Stop shifting if Frostbabe is in combat
        if ($combat_state == 1) {
            return;
        }

        # List of new locations
        my @locations = (
             [-619.32, -150.03, 125.51, 507.75],
            [-359.86, -127.93, 93.55, 338.25],
            [17.93, -73.82, 17.92, 382.00],
            [16.41, 70.95, 5.58, 377.00],
            [136.33, 0.80, -7.46, 399.00],
            [203.62, 66.35, 5.58, 136.75],
            [201.26, -88.80, 5.58, 113.50],
            [522.74, 179.21, -19.75, 361.00],
            [613.16, -107.60, -108.54, 23.00],
            [827.80, -208.65, -134.35, 396.50],
            [957.56, -213.79, -134.35, 393.25],
            [1125.96, -299.99, -114.34, 503.25],
            [1257.17, -527.88, -114.33, 410.25],
            [1368.64, -694.73, -114.33, 8.50],
            [1375.15, -528.86, -114.33, 394.75],
            [1426.54, -779.38, -114.32, 437.75],
            [1424.49, -840.68, -114.34, 3.75],
            [1229.08, -838.58, -129.15, 136.00],
            [1223.29, -769.65, -129.15, 259.50],
            [1217.31, -910.30, -129.15, 7.00],
            [1140.40, -838.74, -124.35, 129.50],
            [1037.42, -653.05, -124.34, 222.75],
            [945.14, -1053.17, -124.34, 73.50],
            [1531.00, -812.22, -114.33, 394.00],
            [1537.39, 0.62, -192.29, 402.00],
            [1639.71, 164.58, -194.33, 236.25],
            [1838.44, 90.02, -194.32, 395.25],
            [1913.54, 95.73, -194.33, 384.50],
            [1966.26, 252.02, -194.33, 275.75],
            [1823.62, 201.83, -194.33, 140.50],
            [1917.32, 322.26, -194.32, 207.25],
            [1795.58, -179.22, -212.23, 132.50],
            [1798.86, -134.67, -212.23, 138.00],
            [2007.04, -239.76, -212.22, 155.25],
            [2374.70, -441.14, -308.37, 143.75],
            [2417.73, -340.37, -323.16, 191.00],
            [2689.31, -327.87, -324.29, 264.00],
            [2717.57, -388.36, -382.14, 101.50],
            [2820.29, -388.46, -391.02, 97.75],
            [2602.33, -617.56, -324.30, 3.25],
            [2508.59, -544.57, -324.27, 115.00],
            [1805.33, -320.32, -214.32, 466.25],
            [1808.78, -248.62, -214.33, 365.75],
            [1752.51, -719.71, -174.35, 493.25],
            [1689.38, -957.62, -174.35, 34.25],
            [1660.30, -1105.09, -154.35, 506.75],
            [1721.28, -1104.97, -154.36, 489.75],
            [1587.13, -1337.70, -154.36, 120.75],
            [1830.03, -1317.53, -154.36, 397.00],
            [1828.95, -1477.30, -194.32, 390.00],
            [1828.26, -1406.06, -194.31, 395.00],
            [1746.98, -1519.07, -194.31, 510.75],
            [1695.37, -1503.83, -194.31, 4.50],
            [1619.99, -1516.62, -194.30, 15.00],
            [1573.41, -1395.05, -194.30, 132.00],
            [1577.27, -1462.28, -194.30, 118.25],
            [1705.38, -1617.81, -154.33, 248.25],
            [1608.10, -1631.85, -154.32, 476.00],
            [1817.94, -1598.82, -154.32, 2.00],
            [1701.59, -1335.91, -154.34, 255.00],
            [1701.57, -1535.56, -126.32, 511.00],
            [1947.97, -1738.39, -154.35, 385.75],
            [1698.26, -1751.62, -154.34, 9.50],
            [1451.51, -1739.44, -154.33, 133.50],
            [1490.13, -1667.55, -154.33, 262.25],
            [1023.76, -53.27, -134.28, 508.25],
            [1064.69, -10.41, -134.27, 100.25],
            [1119.43, 69.93, -134.27, 73.50],
            [1166.45, 152.07, -134.27, 19.00],
            [1262.99, 227.74, -134.26, 336.50],
            [1133.79, 265.80, -134.26, 131.50],
            [1200.63, 342.90, -134.26, 283.25],
            [1277.41, 345.97, -134.26, 355.75],
            [1256.81, 277.05, -134.25, 382.50],
            [1358.53, 299.70, -134.25, 361.25],
            [1343.05, 218.42, -134.24, 510.25],
            [1192.53, 41.59, -134.23, 383.25],
            [1283.29, 40.87, -134.23, 377.75],
            [1269.05, 89.91, -134.23, 245.50],
            [1148.63, -131.84, -134.22, 366.75],
            [1705.07, 31.25, -193.27, 371.25],
            [1876.65, 41.41, -193.79, 399.50],
            [1627.87, -63.92, -191.73, 43.00]
        );

        # Pick a random location
        my $loc = $locations[int(rand(@locations))];
        
        # Despawn and respawn Frostbabe at the new location
        quest::depop();
        quest::spawn2($npc->GetNPCTypeID(), 0, 0, @$loc);
    }
    elsif ($timer eq "life_drain") {
        if ($combat_state == 1) {
            # Only apply life drain during combat
            my $npc_x = $npc->GetX();
            my $npc_y = $npc->GetY();
            my $npc_z = $npc->GetZ();
            my $radius = 50;  # Radius in units around the NPC (adjust as necessary)

            # Drain 1000 HP from players, bots, and pets within the radius
            foreach my $entity ($entity_list->GetClientList()) {
                my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $entity->Damage($npc, 1000, 0, 1, false);  # False to prevent hate list modification
                }
            }

            # Drain 1000 HP from bots within the radius
            foreach my $bot ($entity_list->GetBotList()) {
                my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $bot->Damage($npc, 1000, 0, 1, false);
                }
            }

            # Drain 1000 HP from pets within the radius
            foreach my $entity ($entity_list->GetClientList()) {
                my $pet = $entity->GetPet();  # Get the pet of the player
                if ($pet) {
                    my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                    if ($distance <= $radius) {
                        $pet->Damage($npc, 1000, 0, 1, false);  # Apply damage to the pet
                    }
                }
            }

            # Drain 1000 HP from bot pets within the radius
            foreach my $bot ($entity_list->GetBotList()) {
                my $pet = $bot->GetPet();  # Get the pet of the bot
                if ($pet) {
                    my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                    if ($distance <= $radius) {
                        $pet->Damage($npc, 1000, 0, 1, false);  # Apply damage to the pet
                    }
                }
            }
        }
    }
    elsif ($timer eq "drain_message") {
        # Display message every 20 seconds
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "A chilling darkness continues to spread as The Evasiveness of Frostbane drains your hope and life!");
        }

        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "A chilling darkness continues to spread as The Evasiveness of Frostbane drains your hope and life!");
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Engaged in combat
        quest::settimer("life_drain", 1);         # Start life drain every second
        quest::settimer("drain_message", 20);     # Start the message timer every 20 seconds
        # Send an initial message at the start of combat
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "A chilling darkness spreads as The Evasiveness of Frostbane begins to drain the hope and life from your entire party!");
        }
        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "A chilling darkness spreads as The Evasiveness of Frostbane begins to drain the hope and life from your entire party!");
        }
    } elsif ($combat_state == 0) {  # Combat ends
        quest::stoptimer("life_drain");  # Stop the life drain timer
        quest::stoptimer("drain_message");  # Stop the message timer
        # Optional: Send a message when combat ends
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "The chilling darkness of The Evasiveness of Frostbane recedes, leaving you with only the memory of its drain.");
        }
        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "The chilling darkness of The Evasiveness of Frostbane recedes, leaving you with only the memory of its drain.");
        }
    }
}