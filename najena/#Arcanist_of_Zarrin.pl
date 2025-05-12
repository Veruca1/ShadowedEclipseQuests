sub EVENT_SPAWN {
    # Shout a message when the NPC spawns
    quest::shout("Who would like to die today?");
    
    # Set a timer to trigger every 15 seconds after an initial delay
    quest::settimer("start_tricks", 15);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Ensure a familiar attacks the player throughout the fight, but only spawn one
        my $familiar_id = quest::ChooseRandom(44121, 44122, 44123, 44124);
        quest::spawn2($familiar_id, 0, 0, $x + 10, $y + 10, $z, $h);
        quest::shout("Prepare to face my familiar!");

        # Start the timer for performing tricks
        quest::settimer("wizard_tricks", 15);
    } elsif ($combat_state == 0) {
        # Stop tricks when combat ends
        quest::stoptimer("wizard_tricks");
        quest::shout("You have bested me... for now.");
    }
}

sub EVENT_TIMER {
    if ($timer eq "wizard_tricks") {
        if ($combat_state == 1) { # Ensure the NPC is in combat before performing tricks
            my $random_ability = quest::ChooseRandom(1, 2, 3);

            if ($random_ability == 1) {
                # Spawn a random familiar
                my $familiar_id = quest::ChooseRandom(44121, 44122, 44123, 44124);
                quest::shout("Prepare to face my familiar!");
                quest::spawn2($familiar_id, 0, 0, $x + 10, $y + 10, $z, $h);
            } elsif ($random_ability == 2) {
                # Shadow step the player
                my $client = $entity_list->GetClientByID($userid);
                if ($client) {
                    quest::shout("BEGONE!");
                    $client->MovePC(44, 574.57, -61.85, 4.06, 401.25); # Move player to specified coordinates and heading
                }
            } elsif ($random_ability == 3) {
                # Make the NPC invulnerable for 4 seconds
                quest::shout("Behold the power of my defenses!");
                $npc->SetInvul(1); # Temporarily make the NPC invulnerable
                quest::settimer("invul_end", 4); # Set a timer to end invulnerability after 4 seconds
            }
        }
    } elsif ($timer eq "invul_end") {
        $npc->SetInvul(0); # End invulnerability
        quest::stoptimer("invul_end");
    } elsif ($timer eq "start_tricks") {
        quest::stoptimer("start_tricks");
        # The tricks timer should start only if the NPC is engaged in combat
        if ($combat_state == 1) {
            quest::settimer("wizard_tricks", 15); # Start the tricks timer after the initial delay
        }
    }
}
