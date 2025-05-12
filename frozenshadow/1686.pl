sub EVENT_SPAWN {
    quest::settimer("azrel_shift", 30);  # Timer for shifting between cells every 30 seconds
}

sub EVENT_TIMER {
    if ($timer eq "azrel_shift") {
        # Stop the shift if Azrel is in combat (combat_state == 1)
        if ($combat_state == 1) {
            return;  # Stop the timer action if in combat
        }

        # Select a random location from the 9 locations
        my @locations = (
            [743.00, 749.00, 75.73, 511.00],  # Location 1
            [761.49, 788.76, 74.94, 253.25],  # Location 2
            [796.00, 747.00, 75.73, 511.00],  # Location 3
            [820.00, 803.00, 75.73, 511.00],  # Location 4
            [846.79, 752.54, 74.84, 2.25],    # Location 5
            [848.00, 863.00, 75.73, 511.00],  # Location 6
            [789.77, 806.26, 75.65, 6.25],    # Location 7
            [768.00, 805.00, 75.73, 511.00],  # Location 8
            [733.80, 859.18, 74.83, 256.25]   # Location 9
        );

        # Pick a random location from the array
        my $loc = $locations[int(rand(@locations))];
        
        # Despawn Azrel and spawn him at the new random location
        quest::depop();
        quest::spawn2($npc->GetNPCTypeID(), 0, 0, @$loc);  # Respawn Azrel at the new location
    }
    elsif ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;  # Radius in units around the NPC (adjust as necessary)

        # Drain 1000 HP from players and bots within the radius
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
    elsif ($timer eq "drain_message") {
        # Display message every 20 seconds
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "A chilling darkness continues to spread as Azrel drains your hope and life!");
        }

        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "A chilling darkness continues to spread as Azrel drains your hope and life!");
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Engaged in combat
        quest::settimer("life_drain", 1);         # Start life drain every second
        quest::settimer("drain_message", 20);     # Start the message timer every 20 seconds
        # Send an initial message at the start of combat
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "A chilling darkness spreads as Azrel begins to drain the hope and life from your entire party!");
        }
        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "A chilling darkness spreads as Azrel begins to drain the hope and life from your entire party!");
        }
    } elsif ($combat_state == 0) {  # Combat ends
        quest::stoptimer("life_drain");          # Stop life drain
        quest::stoptimer("drain_message");       # Stop the message timer
        
        # Restart azrel_shift timer if combat ended (Azrel is no longer engaged)
        quest::settimer("azrel_shift", 30);      # Reset the timer to start shifting locations again
    }
}

sub EVENT_DEATH_COMPLETE {
    # Spawn Varketh the Warden at the correct location when Azrel dies
    quest::spawn2(1685, 0, 0, 828.80, 866.36, 74.81, 387.75);  # Varketh's NPC ID and desired location
}
