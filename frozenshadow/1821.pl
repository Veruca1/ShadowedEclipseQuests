sub EVENT_SPAWN {
    quest::settimer("hp_check", 1);  # Start HP check timer every second
    quest::settimer("check_buffs", 1);

    # Initialize databuckets for spawn tracking
    quest::set_data("spawn_74_49", 0);  # Flag for 74-49 health range
    quest::set_data("spawn_49_24", 0);  # Flag for 49-24 health range
    quest::set_data("spawn_24", 0);     # Flag for 24 health or lower

    # Get all clients in the zone
    my @clients = $entity_list->GetClientList();

    # Define the text for the marquee
    my $text = "You hear an annoying giggle in the distance.";

    # Send the marquee message to each client in the zone
    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);  # Broadcasting to all players
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { 
        # Combat starts
        quest::shout("Oh dear, it seems we have a little troublemaker here. *giggle* You should have known better than to enter my domain!");

        # Cast spell 40635 (Zip it!) on all players, bots, and pets in the zone
        my @clients = $entity_list->GetClientList();
        foreach my $client (@clients) {
            $npc->CastSpell(40635, $client->GetID());  # Cast on each player
            my $pet = $client->GetPet();
            if ($pet) {
                $npc->CastSpell(40635, $pet->GetID());  # Cast on the player's pet if it exists
            }
        }

        # Cast on bots
        my @bots = $entity_list->GetBotList();
        foreach my $bot (@bots) {
            $npc->CastSpell(40635, $bot->GetID());  # Cast on each bot
            my $bot_pet = $bot->GetPet();
            if ($bot_pet) {
                $npc->CastSpell(40635, $bot_pet->GetID());  # Cast on the bot's pet if it exists
            }
        }

        # Start the life drain damage effect when the fight begins
        quest::settimer("life_drain", 10);  # Set the timer for life drain every 10 seconds
    } elsif ($combat_state == 0) { 
        # Combat ends
        quest::shout("Well, that was entirely *disappointing*. Perhaps you should have listened more closely to your professors... *giggle*");

        # Stop the life drain effect when the fight ends
        quest::stoptimer("life_drain");

        # Wipe the spawn tracking data after the fight
        quest::delete_data("spawn_74_49");
        quest::delete_data("spawn_49_24");
        quest::delete_data("spawn_24");
    }
}

sub EVENT_TIMER {
    if ($timer eq "hp_check") {
        # Calculate health percentage manually
        my $health_percent = ($npc->GetHP() / $npc->GetMaxHP()) * 100;
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Check health percentage and spawn based on thresholds
        if ($health_percent <= 74 && $health_percent > 49 && quest::get_data("spawn_74_49") == 0) {
            quest::shout("The air crackles with magic as shadowy figures emerge!");
            for (my $i = 0; $i < 1; $i++) {
                quest::spawn2(1822, 0, 0, $x, $y, $z, $h);
            }
            quest::set_data("spawn_74_49", 1);  # Mark this threshold as spawned
        } 
        elsif ($health_percent <= 49 && $health_percent > 24 && quest::get_data("spawn_49_24") == 0) {
            quest::shout("A dark presence intensifies, bringing more minions to aid!");
            for (my $i = 0; $i < 2; $i++) {
                quest::spawn2(1822, 0, 0, $x, $y, $z, $h);
            }
            quest::set_data("spawn_49_24", 1);  # Mark this threshold as spawned
        } 
        elsif ($health_percent <= 24 && quest::get_data("spawn_24") == 0) {
            quest::shout("The ground trembles as a final wave of horrors materializes!");
            for (my $i = 0; $i < 3; $i++) {
                quest::spawn2(1822, 0, 0, $x, $y, $z, $h);
            }
            quest::stoptimer("hp_check");  # Stop timer after last wave
            quest::set_data("spawn_24", 1);  # Mark this threshold as spawned
        }

        # Ranged attack immunity check
        if ($health_percent <= 50) {
            $npc->SetSpecialAbility(46, 1); # Enable ranged immunity
        } else {
            $npc->SetSpecialAbility(46, 0); # Disable ranged immunity
        }
    }

    if ($timer eq "life_drain") {
        # Apply the life drain effect (damage) to all players and bots in the vicinity
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 100;  # Updated radius to 100 units

        # Apply damage to players in radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 1000, 0, 1, false); # Apply 1000 damage, no hate modification
            }
        }

        # Apply damage to bots in radius
        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, 1000, 0, 1, false);
            }
        }

        # Apply damage to pets of players
        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 1000, 0, 1, false);
                }
            }
        }

        # Apply damage to pets of bots
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 1000, 0, 1, false);
                }
            }
        }
    }

    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        $npc->CastSpell(23299, $npc->GetID()) if !$npc->FindBuff(23299);
    }
}
