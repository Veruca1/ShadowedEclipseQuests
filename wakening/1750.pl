sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("life_drain", 35);  # Drain every 35 seconds
        quest::settimer("drain_message", 35);  # Message syncs with drain

        # Initial warning message
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "The earth rumbles as the Geonid Shepherd awakens, its presence crushing the very air around you!");
        }
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "The earth rumbles as the Geonid Shepherd awakens, its presence crushing the very air around you!");
        }
    } 
    elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("life_drain");        
        quest::stoptimer("drain_message");      
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;  # Effect range

        # Random damage between 10,000 and 20,000 HP
        my $damage_amount = plugin::RandomRange(10000, 20000); 

        # Apply damage to players and bots
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, $damage_amount, 0, 1, false);
            }
        }
        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, $damage_amount, 0, 1, false);
            }
        }

        # Apply damage to pets
        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, $damage_amount, 0, 1, false);
                }
            }
        }
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, $damage_amount, 0, 1, false);
                }
            }
        }
    }
    elsif ($timer eq "drain_message") {
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "The Geonid Shepherd lets out a deep, grinding growl as stone fractures and dust fills the air—your life force is slipping away!");
        }
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "The Geonid Shepherd lets out a deep, grinding growl as stone fractures and dust fills the air—your life force is slipping away!");
        }
    }
}
