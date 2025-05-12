sub EVENT_SPAWN {
    $npc->CameraEffect(1000, 3);

    # Cast the spell on herself at spawn if not already buffed
    $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

    # Send a message to all clients in the zone
    my @clients = $entity_list->GetClientList();
    my $text = "You hear fighting in the distance";
    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
    }
}

sub EVENT_HP { 
    if ($npc->GetHPRatio() <= 50) {
        quest::modifynpcstat("special_abilities", "46,1");
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Engaged in combat
        quest::settimer("cast_spell", 50);  # Every 5 seconds
        quest::settimer("spawn_adds", 60);  # Set timer to spawn adds every 1 minute during combat
        quest::settimer("life_drain", 60);  # Start life drain every 1 minute
    } 
    elsif ($combat_state == 0) {  # Out of combat
        quest::stoptimer("cast_spell");
        quest::stoptimer("spawn_adds");  # Stop the spawn_adds timer when leaving combat
        quest::stoptimer("life_drain");  # Stop life drain when out of combat
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_spell") {
        my $target = $npc->GetHateTop();  
        if ($target) {
            my @clients = $entity_list->GetClientList();
            foreach my $client (@clients) {
                # Get the NPC's current position
                my $npc_x = $npc->GetX();
                my $npc_y = $npc->GetY();
                my $npc_z = $npc->GetZ();

                # Get the client's position
                my $client_x = $client->GetX();
                my $client_y = $client->GetY();
                my $client_z = $client->GetZ();

                # Calculate the distance between the NPC and the client in XYZ coordinates
                my $distance = sqrt(($npc_x - $client_x)**2 + ($npc_y - $client_y)**2 + ($npc_z - $client_z)**2);

                # Define a maximum range for the spell (e.g., 100 units)
                my $max_range = 100;

                # Check if the client is within range
                if ($distance <= $max_range) {
                    $npc->CastSpell(40633, $client->GetID());  # Cast on the client

                    my $pet = $client->GetPet();
                    if ($pet) {
                        $npc->CastSpell(40633, $pet->GetID());  # Cast on the player's pet if it exists
                    }
                }
            }
        }
    }
    elsif ($timer eq "spawn_adds") {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Spawn 5 adds in a circle around the NPC
        for my $i (0..4) {  
            my $angle = $i * (2 * 3.14159 / 5);  # Adjust angle for 5 adds
            my $add_x = $x + 10 * cos($angle);
            my $add_y = $y + 10 * sin($angle);
            quest::spawn2(1830, 0, 0, $add_x, $add_y, $z, $h);
        }
    }
    elsif ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;

        # Drain 45,000 HP from players and bots within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $entity->Damage($npc, 45000, 0, 1, false);
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $bot->Damage($npc, 45000, 0, 1, false);
            }
        }

        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, 45000, 0, 1, false);
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, 45000, 0, 1, false);
            }
        }

        # Schedule the next life drain in 1 minute
        quest::settimer("life_drain", 60);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1816, 2);  # Signal with NPC ID 1816
}
