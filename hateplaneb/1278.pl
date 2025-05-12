my $phase = 1;

sub EVENT_SPAWN {
    # Initial setup
    quest::settimer("phase_change", 5 * 60); # Check for phase change every 5 minutes
    quest::settimer("environmental_hazard", 30); # Environmental hazard every 30 seconds
    quest::settimer("spawn_adds", 50); # Spawn NPC ID 1267 every 50 seconds
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Combat started
        quest::settimer("phase_change", 5 * 60); # Start phase change timer
        quest::settimer("environmental_hazard", 30); # Start environmental hazard timer
        quest::settimer("spawn_adds", 50); # Start add spawning timer

        # Send a marquee message on engagement
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Stupid mortals! Worked so hard to make it all this way only to die! Hahahaha!!!!");
        }
    } else { # Combat ended or the NPC is not engaged
        quest::stoptimer("phase_change");
        quest::stoptimer("environmental_hazard");
        quest::stoptimer("spawn_adds");
    }
}

sub EVENT_TIMER {
    # Only proceed if the NPC is engaged/in combat
    if ($npc->IsEngaged()) {
        if ($timer eq "phase_change") {
            if ($npc->GetHP() < 66 && $phase == 1) {
                $phase = 2;
                # Phase 2: Increase difficulty
                quest::settimer("environmental_hazard", 20); # Hazard more frequent
            }
            elsif ($npc->GetHP() < 33 && $phase == 2) {
                $phase = 3;
                # Phase 3: Final phase changes
                quest::settimer("environmental_hazard", 10); # Hazard even more frequent
            }
        }
        elsif ($timer eq "environmental_hazard") {
            # Environmental hazard: random spell or effect
            my $hazard_spell = quest::ChooseRandom(36834, 4162, 36835); # Eruption of Flames, Toxic Cloud, Frozen Ground

            # Marquee messaging for environmental hazards
            if ($hazard_spell == 36834) {
                my @client_list = $entity_list->GetClientList();
                foreach my $client (@client_list) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The ground erupts in flames!");
                }
            }
            elsif ($hazard_spell == 4162) {
                my @client_list = $entity_list->GetClientList();
                foreach my $client (@client_list) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "A toxic cloud spreads across the battlefield!");
                }
            }
            elsif ($hazard_spell == 36835) {
                my @client_list = $entity_list->GetClientList();
                foreach my $client (@client_list) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The ground beneath you starts to freeze!");
                }
            }

            # Cast the hazard spell on all players and bots in range
            my @target_list = $entity_list->GetClientList();
            foreach my $target (@target_list) {
                quest::castspell($hazard_spell, $target->GetID());
            }
        }
        elsif ($timer eq "spawn_adds") {
            # Spawn NPC ID 1267 every 50 seconds
            quest::spawn2(1267, 0, 0, $npc->GetX() + rand(20), $npc->GetY() + rand(20), $npc->GetZ(), $npc->GetHeading());
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Ensure this is the correct NPC dying (ID 186107)
    quest::shout("Noooo! It can't end this way!"); # Zone shout on death

    # Spawn Evangelist of Hate (ID 186198) at specific location
    quest::unique_spawn(186198, 0, 0, -460, -1455, 65, 255); # Location and heading
}
