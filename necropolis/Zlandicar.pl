# File: 1813.pl

sub EVENT_SPAWN {   
    $npc->CameraEffect(1000, 3);    

    # Get all clients in the zone
    my @clients = $entity_list->GetClientList();

    # Define the text for the marquee
    my $text = "You feel a disturbance and great evil to the west.";

    # Send the marquee message to each client in the zone
    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);  # Broadcasting to all players
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { 
        # Combat starts
        quest::shout("Foolish mortals, you dare trespass in my lair? Your bones will join my collection!");

        # Cast spell 13421 on all players, bots, and pets in the zone
        my @clients = $entity_list->GetClientList();
        foreach my $client (@clients) {
            $npc->CastSpell(13421, $client->GetID());  # Cast on each player
            my $pet = $client->GetPet();
            if ($pet) {
                $npc->CastSpell(13421, $pet->GetID());  # Cast on the player's pet if it exists
            }
        }

        # Cast on bots
        my @bots = $entity_list->GetBotList();
        foreach my $bot (@bots) {
            $npc->CastSpell(13421, $bot->GetID());  # Cast on each bot
            my $bot_pet = $bot->GetPet();
            if ($bot_pet) {
                $npc->CastSpell(13421, $bot_pet->GetID());  # Cast on the bot's pet if it exists
            }
        }

        # Start the life drain damage effect when the fight begins
        quest::settimer("life_drain", 10);  # Set the timer for life drain every 10 seconds
    } elsif ($combat_state == 0) { 
        # Combat ends
        quest::shout("You have merely delayed the inevitable... my hunger is eternal...");
        
        # Stop the life drain effect when the fight ends
        quest::stoptimer("life_drain");  # Stop the timer for life drain
    }
}

sub EVENT_HEALTH {
    if ($npc->GetHealthPercent() <= 50) {
        # Set immunity to ranged attacks (ID 46) with flag 1
        $npc->SetSpecialAbility(46, 1); # 46 is the ability ID, 1 is the value for immunity
    } else {
        # Remove immunity to ranged attacks if health is above 50%
        $npc->SetSpecialAbility(46, 0); # Set to 0 to remove the immunity
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        # Apply the life drain effect (damage) to all players and bots in the vicinity
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 100;  # Updated radius to 100 units

        # Drain 5000 HP from players within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 5000, 0, 1, false); # Apply 5000 damage, no hate modification
            }
        }

        # Drain 5000 HP from bots within the radius
        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, 5000, 0, 1, false); # Apply 5000 damage to bot
            }
        }

        # Drain 5000 HP from pets within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet(); # Get the pet of the player
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 5000, 0, 1, false); # Apply 5000 damage to the pet
                }
            }
        }

        # Drain 5000 HP from bot pets within the radius
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet(); # Get the pet of the bot
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 5000, 0, 1, false); # Apply 5000 damage to the pet
                }
            }
        }
    }
}
