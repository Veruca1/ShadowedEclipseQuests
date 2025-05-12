sub EVENT_SPAWN {
    # Shout upon spawn
    quest::shout("Hehehe Catch me if you can!");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("life_drain", 40);         # Start life drain every 40 seconds
        quest::settimer("drain_message", 40);      # Start the message timer every 40 seconds
        # Send an initial message at the start of combat
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Kreel The Insatiable is hungry, and he's coming for you!");
        }
        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "Kreel The Insatiable is hungry, and he's coming for you!");
        }
    } elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("life_drain");          # Stop life drain
        quest::stoptimer("drain_message");       # Stop the message timer
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;  # Radius in units around the NPC (adjust as necessary)

        # Drain 10000 HP from players and bots within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 10000, 0, 1, false); # False to prevent hate list modification
            }
        }
        
        # Drain 10000 HP from bots within the radius
        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, 10000, 0, 1, false);
            }
        }

        # Drain 10000 HP from pets within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet(); # Get the pet of the player
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 10000, 0, 1, false); # Apply damage to the pet
                }
            }
        }

        # Drain 10000 HP from bot pets within the radius
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet(); # Get the pet of the bot
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 10000, 0, 1, false); # Apply damage to the pet
                }
            }
        }
    }
    elsif ($timer eq "drain_message") {
        # Display message every 40 seconds
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Kreel The Insatiable is getting hungrier and hungrier!");
        }

        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "Kreel The Insatiable is getting hungrier and hungrier!");
        }

        # Kreel throws food at the party every 40 seconds
        my @food_items = ('a drumstick', 'a loaf of bread', 'a corn cob', 'hot soup');
        my $food_variable = $food_items[int(rand(@food_items))]; # Randomly choose one food item
        
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Kreel The Insatiable throws $food_variable at you!");
        }
        
        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "Kreel The Insatiable throws $food_variable at you!");
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 4); # Sends signal 4 to zone_controller with NPC ID 10
}
