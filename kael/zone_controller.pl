sub EVENT_SPAWN {
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
    );

    my @npc_ids = (1759, 1760, 1761, 1762);

    foreach my $loc (@locations) {
        my ($x, $y, $z, $h) = @$loc;
        my $npc_id = $npc_ids[int(rand(@npc_ids))];  # Randomly pick NPC ID
        
        # Debug: Log the location and NPC ID chosen for spawn
        #quest::shout("DEBUG: Spawning NPC $npc_id at location ($x, $y, $z, $h)");

        # 5% chance for NPC 1763 to spawn instead of one of the tracked NPCs
        if (rand(100) < 5 && !quest::isnpcspawned(1763)) {
            #quest::shout("DEBUG: Spawning NPC 1763 at location ($x, $y, $z, $h)");
            quest::spawn2(1763, 0, 0, $x, $y, $z, $h);
        } else {
            quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
        }
    }

    # Spawn NPC 1771 at a random location
    my $rand_loc = $locations[int(rand(@locations))];
    #quest::shout("DEBUG: Spawning NPC 1771 at random location ($rand_loc->[0], $rand_loc->[1], $rand_loc->[2], $rand_loc->[3])");
    quest::spawn2(1771, 0, 0, $rand_loc->[0], $rand_loc->[1], $rand_loc->[2], $rand_loc->[3]);
}


sub EVENT_DEATH_ZONE {
    my $killed_npc = $entity_list->GetMobByID($killed_entity_id);  # Get the actual NPC that died

    if ($killed_npc) {
        my $killed_npc_id = $killed_npc->GetID();  # Get the ID of the killed NPC

        # Check if the killed NPC is one of the specified NPCs (1759, 1760, 1761, 1762)
        if ($killed_npc_id == 1759 || $killed_npc_id == 1760 || $killed_npc_id == 1761 || $killed_npc_id == 1762) {

            my $x = $killed_npc->GetX();
            my $y = $killed_npc->GetY();
            my $z = $killed_npc->GetZ();
            my $h = $killed_npc->GetHeading();

            # Ensure we're getting valid coordinates
            if (!defined $x || !defined $y || !defined $z || !defined $h) {
                quest::shout("ERROR: Invalid death coordinates detected!");
                return;
            }

            my @npc_ids = (1759, 1760, 1761, 1762, 1763, 1771);

            # 25% chance for 1763 and 1771, otherwise evenly spread between 1759-1762
            my $rand_roll = rand(100);
            my $respawn_npc;

            # Ensure 1763 doesn't spawn if it's already present
            if ($rand_roll < 25 && !quest::isnpcspawned(1763)) {
                $respawn_npc = 1763;
            } else {
                my @other_npcs = (1759, 1760, 1761, 1762, 1771);
                $respawn_npc = $other_npcs[int(rand(@other_npcs))];
            }

            # Ensure 1771 doesn't spawn if it's already present
            if ($rand_roll < 25 && !quest::isnpcspawned(1771)) {
                $respawn_npc = 1771;
            } else {
                my @other_npcs = (1759, 1760, 1761, 1762, 1763);
                $respawn_npc = $other_npcs[int(rand(@other_npcs))];
            }

            # Store respawn info with a unique key (NPC ID + timestamp for uniqueness)
            my $respawn_key = "respawn_" . time();
            quest::set_data($respawn_key, "$x|$y|$z|$h|" . join(",", @npc_ids));

            # Set a timer to respawn in 5 seconds
            quest::settimer($respawn_key, 5);
        }
    } else {
        #quest::shout("ERROR: Unable to fetch killed NPC entity!");
    }
}


sub EVENT_TIMER {
    if ($timer =~ /^respawn_(.*)/) {
        my $respawn_key = $1;
        my $data = quest::get_data("respawn_$respawn_key");

        if ($data) {
            my ($x, $y, $z, $h, $npc_list) = split(/\|/, $data);

            if (!defined $x || !defined $y || !defined $z || !defined $h) {
                quest::shout("ERROR: Invalid coordinates or heading for respawn.");
                return;
            }

            my @npc_ids = split(/,/, $npc_list);
            my $npc_id = $npc_ids[int(rand(@npc_ids))];

            #quest::shout("DEBUG: Respawning NPC ID $npc_id at ($x, $y, $z, $h)");
            quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);

            # Stop timer after respawn
            quest::stoptimer($timer);
        } else {
            #quest::shout("ERROR: No data found for respawn key $respawn_key");
        }
    }
}