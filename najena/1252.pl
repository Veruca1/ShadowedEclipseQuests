my $vanish_count = 0;

sub EVENT_SPAWN {
    # Retrieve the stored HP percentage from the global variable
    my $stored_hp_percentage = $qglobals{"new_npc_hp"};

    if ($stored_hp_percentage) {
        my $new_hp = $npc->GetMaxHP() * ($stored_hp_percentage / 100);
        $npc->SetHP($new_hp);
    }

    # Set the HP event to 30%
    quest::setnexthpevent(30);

    # Start the tricks timer after an initial delay
    quest::settimer("magician_tricks", 25);
}

sub EVENT_HP {
    if ($hpevent == 30) {
        quest::shout("You dare keep attacking me? Feel my wrath!");
        # Additional actions at 30% HP can be added here
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Ensure an elemental attacks the player throughout the fight, but only spawn one
        my $elemental_id = quest::ChooseRandom(170210, 170229, 170225); # New elemental IDs
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
                my $elemental_id = quest::ChooseRandom(170210, 170229, 170225); # New elemental IDs
                quest::shout("Feel the might of my elementals!");
                quest::spawn2($elemental_id, 0, 0, $x + 10, $y + 10, $z, $h);
            } elsif ($random_ability == 2) {
                # Handle teleportation and respawn the NPC at a new location
                quest::shout("Watch as I vanish!");

                # Capture the current HP percentage
                my $hp_percentage = ($npc->GetHP() / $npc->GetMaxHP()) * 100;

                # Depop the current NPC
                quest::depop();

                # Store the HP percentage for the next NPC to use
                quest::setglobal("new_npc_hp", $hp_percentage, 7, "M10");

                # Alternate between the original location and a new location
                if ($vanish_count % 2 == 0) {
                    quest::spawn2(1253, 0, 0, 456.37, -48.45, 4.35, 412); # Spawns the second teleported NPC
                } else {
                    quest::spawn2(44119, 0, 0, 350.91, -30.77, 4.55, 105); # Spawns the original NPC at a different location
                }

                $vanish_count++;
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
    }
}
