sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("life_drain", 1);         # Start life drain every second
        quest::settimer("drain_message", 20);    # Start the message timer every 20 seconds
        # Send an initial message at the start of combat
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "A chilling darkness spreads as the Dementor guard begins to drain the hope and life from your entire party!");
        }
        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
          # #$bot->Message(14, "A chilling darkness spreads as the Dementor guard begins to drain the hope and life from your entire party!");
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

        # Drain 1000 HP from players and bots within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 1000, 0, 1, false); # False to prevent hate list modification
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
            my $pet = $entity->GetPet(); # Get the pet of the player
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 1000, 0, 1, false); # Apply damage to the pet
                }
            }
        }

        # Drain 1000 HP from bot pets within the radius
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet(); # Get the pet of the bot
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 1000, 0, 1, false); # Apply damage to the pet
                }
            }
        }
    }
    elsif ($timer eq "drain_message") {
        # Display message every 20 seconds
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "A chilling darkness continues to spread as the Dementor guard drains your hope and life!");
        }

        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "A chilling darkness continues to spread as the Dementor guard drains your hope and life!");
        }
    }
}
