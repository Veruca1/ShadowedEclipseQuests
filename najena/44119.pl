my $vanish_count = 0;
my $teleport_timer = 10; # Time in seconds before the NPC reappears
my $stored_hp; # To store the NPC's health
my $new_x;
my $new_y;
my $new_z;

sub EVENT_SPAWN {
    # Shout a message when the NPC spawns
    quest::shout("Welcome to your doom!");

    # Store the NPC's initial position and heading
    $original_x = $x;
    $original_y = $y;
    $original_z = $z;
    $original_heading = $h;

    # Set the HP event to 30%
    quest::setnexthpevent(30);

    # Start the tricks timer
    quest::settimer("magician_tricks", 25);
}

sub EVENT_HP {
    if ($hpevent == 30) {
        quest::shout("You dare keep attacking me? Feel my wrath!");
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Ensure an elemental attacks the player throughout the fight, but only spawn one
        my $elemental_id = quest::ChooseRandom(2206, 2205, 2204); # New elemental IDs
        quest::spawn2($elemental_id, 0, 0, $x + 10, $y + 10, $z, $h);
        quest::shout("Behold my magical prowess!");
    } elsif ($combat_state == 0) {
        # Stop tricks when combat ends
        quest::stoptimer("magician_tricks");
        quest::shout("You have proven yourself... this time.");
    }
}

sub EVENT_TIMER {
    if ($timer eq "magician_tricks") {
        if ($combat_state == 1) { # Ensure the NPC is in combat before performing tricks
            my $random_ability = quest::ChooseRandom(1, 2, 3);

            if ($random_ability == 1) {
                # Spawn a random elemental
                my $elemental_id = quest::ChooseRandom(2206, 2205, 2204); # New elemental IDs
                quest::shout("Feel the might of my elementals!");
                quest::spawn2($elemental_id, 0, 0, $x + 10, $y + 10, $z, $h);
            } elsif ($random_ability == 2) {
                # Handle teleportation
                # Store the current health before moving
                $stored_hp = $npc->GetHP();

                # Alternate between the two teleport locations
                if ($vanish_count % 2 == 0) {
                    $new_x = $x + 50; # Move 50 units in X direction as an example
                    $new_y = $y + 50; # Move 50 units in Y direction as an example
                    $new_z = $z;      # Keep the same Z coordinate
                } else {
                    $new_x = $x - 50; # Move -50 units in X direction as an example
                    $new_y = $y - 50; # Move -50 units in Y direction as an example
                    $new_z = $z;      # Keep the same Z coordinate
                }

                $vanish_count++;

                # Move the NPC to the new location
                quest::moveto($new_x, $new_y, $new_z, $h, 1);

                # Set a timer to ensure the NPC becomes visible again after teleporting
                quest::settimer("visibility", $teleport_timer);
            } elsif ($random_ability == 3) {
                # Create a magical barrier that absorbs damage for 4 seconds
                quest::shout("A magical barrier protects me!");
                $npc->SetInvul(1); # Temporarily make the NPC invulnerable
                quest::settimer("invul_end", 4); # Set a timer to end invulnerability after 4 seconds
            }
        }
    } elsif ($timer eq "invul_end") {
        $npc->SetInvul(0); # End invulnerability
        quest::stoptimer("invul_end");
    } elsif ($timer eq "visibility") {
        # Restore NPC health after teleporting
        $npc->SetHP($stored_hp);

        quest::shout("I have returned with my full strength!");
        quest::stoptimer("visibility");
    }
}
