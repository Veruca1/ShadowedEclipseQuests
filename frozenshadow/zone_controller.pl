my $signal_count = 0;
my $target_signal_count = int(rand(16)) + 1;  # Generate a random number between 1 and 16

sub EVENT_SPAWN {
    #Spawn NPC 1735 at loc below
    quest::spawn2(1735, 0, 0, 170.78, 970.22, 117.74, 4.00);

    # Spawn NPC 1684 at the specified locations
    quest::spawn2(1684, 0, 0, 743.00, 749.00, 75.73, 511.00); # Location 1
    quest::spawn2(1684, 0, 0, 761.49, 788.76, 74.94, 253.25); # Location 2
    quest::spawn2(1684, 0, 0, 796.00, 747.00, 75.73, 511.00); # Location 3
    quest::spawn2(1684, 0, 0, 820.00, 803.00, 75.73, 511.00); # Location 4
    quest::spawn2(1684, 0, 0, 846.79, 752.54, 74.84, 2.25);   # Location 5
    quest::spawn2(1684, 0, 0, 848.00, 863.00, 75.73, 511.00); # Location 6
    quest::spawn2(1684, 0, 0, 789.77, 806.26, 75.65, 6.25);   # Location 7
    quest::spawn2(1684, 0, 0, 768.00, 805.00, 75.73, 511.00); # Location 8
    quest::spawn2(1684, 0, 0, 733.80, 859.18, 74.83, 256.25); # Location 9

    # Spawn new NPCs: 1689 Cook at specified locations
    quest::spawn2(1689, 0, 0, 466.42, 758.93, 76.71, 118.75); # Location 1
    quest::spawn2(1689, 0, 0, 511.91, 763.84, 76.71, 127.00); # Location 2
    quest::spawn2(1689, 0, 0, 512.72, 806.45, 76.71, 132.75); # Location 3
    quest::spawn2(1689, 0, 0, 452.59, 810.12, 76.71, 130.25); # Location 4

    # Spawn new NPCs: 1687 Mess Hall Guard at specified locations
    quest::spawn2(1687, 0, 0, 425.39, 916.16, 76.70, 125.50); # Location 1
    quest::spawn2(1687, 0, 0, 513.93, 915.62, 76.70, 136.75); # Location 2
    quest::spawn2(1687, 0, 0, 515.62, 862.03, 76.70, 132.25); # Location 3
    quest::spawn2(1687, 0, 0, 431.11, 861.75, 76.70, 126.00); # Location 4

    # Spawn new NPCs: 1691 A Pool Guard at specified locations
    quest::spawn2(1691, 0, 0, 428.83, 983.59, 69.81, 127.25); # Location 1
    quest::spawn2(1691, 0, 0, 502.21, 984.48, 69.81, 133.75); # Location 2
    quest::spawn2(1691, 0, 0, 499.40, 1065.52, 69.81, 130.50); # Location 3
    quest::spawn2(1691, 0, 0, 428.44, 1066.56, 69.81, 135.00); # Location 4

    # Spawn new NPCs: 1690 A Prison Guard at specified locations
    quest::spawn2(1690, 0, 0, 493.79, 1167.80, 69.80, 139.50); # Location 1
    quest::spawn2(1690, 0, 0, 497.24, 1120.53, 69.80, 129.25); # Location 2
    quest::spawn2(1690, 0, 0, 428.46, 1122.16, 69.80, 121.00); # Location 3
    quest::spawn2(1690, 0, 0, 446.53, 1170.24, 72.73, 130.50); # Location 4

    # Spawn 1693
    quest::spawn2(1693, 0, 0, 630.53, 1126.09, 74.73, 384.75);

    # Randomly choose one of the 9 locations to spawn NPC 1686
    my $random_location = int(rand(9)); # Generate a random number between 0 and 8 (for 9 locations)

    if ($random_location == 0) {
        quest::spawn2(1686, 0, 0, 743.00, 749.00, 75.73, 511.00); # Location 1
    }
    elsif ($random_location == 1) {
        quest::spawn2(1686, 0, 0, 761.49, 788.76, 74.94, 253.25); # Location 2
    }
    elsif ($random_location == 2) {
        quest::spawn2(1686, 0, 0, 796.00, 747.00, 75.73, 511.00); # Location 3
    }
    elsif ($random_location == 3) {
        quest::spawn2(1686, 0, 0, 820.00, 803.00, 75.73, 511.00); # Location 4
    }
    elsif ($random_location == 4) {
        quest::spawn2(1686, 0, 0, 846.79, 752.54, 74.84, 2.25);   # Location 5
    }
    elsif ($random_location == 5) {
        quest::spawn2(1686, 0, 0, 848.00, 863.00, 75.73, 511.00); # Location 6
    }
    elsif ($random_location == 6) {
        quest::spawn2(1686, 0, 0, 789.77, 806.26, 75.65, 6.25);   # Location 7
    }
    elsif ($random_location == 7) {
        quest::spawn2(1686, 0, 0, 768.00, 805.00, 75.73, 511.00); # Location 8
    }
    elsif ($random_location == 8) {
        quest::spawn2(1686, 0, 0, 733.80, 859.18, 74.83, 256.25); # Location 9
    }
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Signal 1 logic - 8% chance to spawn NPC 1665
        my $random_roll = int(rand(100)) + 1; # Generate a random number between 1 and 100
        if ($random_roll <= 10) { # 10% chance
            if (!quest::isnpcspawned(1665)) { # Check if NPC 1665 is already spawned
                quest::spawn2(1665, 0, 0, 801.00, 624.00, 12.85, 141.00); # Spawn NPC 1665 at specified location
            }
        }
    }
    elsif ($signal == 2) {
        # Signal 2 logic - Respawn NPC 1684 at all 9 locations and spawn NPC 1686 at a random location
        quest::spawn2(1684, 0, 0, 743.00, 749.00, 75.73, 511.00); # Location 1
        quest::spawn2(1684, 0, 0, 761.49, 788.76, 74.94, 253.25); # Location 2
        quest::spawn2(1684, 0, 0, 796.00, 747.00, 75.73, 511.00); # Location 3
        quest::spawn2(1684, 0, 0, 820.00, 803.00, 75.73, 511.00); # Location 4
        quest::spawn2(1684, 0, 0, 846.79, 752.54, 74.84, 2.25);   # Location 5
        quest::spawn2(1684, 0, 0, 848.00, 863.00, 75.73, 511.00); # Location 6
        quest::spawn2(1684, 0, 0, 789.77, 806.26, 75.65, 6.25);   # Location 7
        quest::spawn2(1684, 0, 0, 768.00, 805.00, 75.73, 511.00); # Location 8
        quest::spawn2(1684, 0, 0, 733.80, 859.18, 74.83, 256.25); # Location 9

        # Randomly choose one of the 9 locations to spawn NPC 1686
        my $random_location = int(rand(9)); # Generate a random number between 0 and 8 (for 9 locations)

        if ($random_location == 0) {
            quest::spawn2(1686, 0, 0, 743.00, 749.00, 75.73, 511.00); # Location 1
        }
        elsif ($random_location == 1) {
            quest::spawn2(1686, 0, 0, 761.49, 788.76, 74.94, 253.25); # Location 2
        }
        elsif ($random_location == 2) {
            quest::spawn2(1686, 0, 0, 796.00, 747.00, 75.73, 511.00); # Location 3
        }
        elsif ($random_location == 3) {
            quest::spawn2(1686, 0, 0, 820.00, 803.00, 75.73, 511.00); # Location 4
        }
        elsif ($random_location == 4) {
            quest::spawn2(1686, 0, 0, 846.79, 752.54, 74.84, 2.25);   # Location 5
        }
        elsif ($random_location == 5) {
            quest::spawn2(1686, 0, 0, 848.00, 863.00, 75.73, 511.00); # Location 6
        }
        elsif ($random_location == 6) {
            quest::spawn2(1686, 0, 0, 789.77, 806.26, 75.65, 6.25);   # Location 7
        }
        elsif ($random_location == 7) {
            quest::spawn2(1686, 0, 0, 768.00, 805.00, 75.73, 511.00); # Location 8
        }
        elsif ($random_location == 8) {
            quest::spawn2(1686, 0, 0, 733.80, 859.18, 74.83, 256.25); # Location 9
        }
    }
    elsif ($signal == 3) {
        # Signal 3 logic - Choose a random number between 1 and 16, wait for the matching number of signal 3's
        if ($signal_count < $target_signal_count) {
            $signal_count++;
        }

        if ($signal_count >= $target_signal_count) {
            # Depop all the specified NPCs
            quest::depopall(1687); # Mess Hall Guard
            quest::depopall(1689); # Cook
            quest::depopall(1690); # A Prison Guard
            quest::depopall(1691); # A Pool Guard

            # Randomly pick a location to spawn NPC 1692
            my $random_location = int(rand(4)); # Choose a number between 0 and 3 for 4 locations

            if ($random_location == 0) {
                quest::spawn2(1692, 0, 0, 459.65, 1028.73, 65.70, 128.25); # Location 1
            }
            elsif ($random_location == 1) {
                quest::spawn2(1692, 0, 0, 451.90, 888.59, 79.93, 127.75); # Location 2
            }
            elsif ($random_location == 2) {
                quest::spawn2(1692, 0, 0, 427.86, 750.33, 74.74, 65.50);  # Location 3
            }
            elsif ($random_location == 3) {
                quest::spawn2(1692, 0, 0, 470.13, 1143.47, 69.48, 125.50); # Location 4
            }

            # Reset signal count and target signal count for the next phase
            $signal_count = 0;
            $target_signal_count = int(rand(16)) + 1;  # Generate a new random number between 1 and 16
        }
    }
    elsif ($signal == 4) {
        # Signal 4 logic - Respawn the specified NPCs
        quest::spawn2(1689, 0, 0, 466.42, 758.93, 76.71, 118.75); # Location 1
        quest::spawn2(1689, 0, 0, 511.91, 763.84, 76.71, 127.00); # Location 2
        quest::spawn2(1689, 0, 0, 512.72, 806.45, 76.71, 132.75); # Location 3
        quest::spawn2(1689, 0, 0, 452.59, 810.12, 76.71, 130.25); # Location 4

        quest::spawn2(1687, 0, 0, 425.39, 916.16, 76.70, 125.50); # Location 1
        quest::spawn2(1687, 0, 0, 513.93, 915.62, 76.70, 136.75); # Location 2
        quest::spawn2(1687, 0, 0, 515.62, 862.03, 76.70, 132.25); # Location 3
        quest::spawn2(1687, 0, 0, 431.11, 861.75, 76.70, 126.00); # Location 4

        quest::spawn2(1691, 0, 0, 428.83, 983.59, 69.81, 127.25); # Location 1
        quest::spawn2(1691, 0, 0, 502.21, 984.48, 69.81, 133.75); # Location 2
        quest::spawn2(1691, 0, 0, 499.40, 1065.52, 69.81, 130.50); # Location 3
        quest::spawn2(1691, 0, 0, 428.44, 1066.56, 69.81, 135.00); # Location 4

        quest::spawn2(1690, 0, 0, 493.79, 1167.80, 69.80, 139.50); # Location 1
        quest::spawn2(1690, 0, 0, 497.24, 1120.53, 69.80, 129.25); # Location 2
        quest::spawn2(1690, 0, 0, 428.46, 1122.16, 69.80, 121.00); # Location 3
        quest::spawn2(1690, 0, 0, 446.53, 1170.24, 72.73, 130.50); # Location 4
    }
    elsif ($signal == 5) {
        # Signal 5 logic - Start a 10-minute timer, then spawn NPC 1693
        quest::settimer("spawn_npc_1693", 600); # 600 seconds = 10 minutes
    }
    elsif ($signal == 6) {
        # Signal 6 logic - 25% chance to spawn NPC 111163
        my $random_roll = int(rand(100)) + 1;
        if ($random_roll <= 25) { # 25% chance
            if (!quest::isnpcspawned(111163)) { # Check if NPC is already spawned
                quest::spawn2(111163, 0, 0, 199.70, 984.97, 185.86, 0.50); # Adjust location as needed
            }
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc_1693") {
        quest::spawn2(1693, 0, 0, 400.00, 600.00, 30.00, 0.00); # Spawn NPC 1693 at specified location
        quest::stoptimer("spawn_npc_1693");
    }
}
