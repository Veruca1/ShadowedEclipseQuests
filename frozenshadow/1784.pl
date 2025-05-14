sub EVENT_COMBAT {
    if ($combat_state == 1) {  # NPC is engaged in combat
        quest::settimer("life_drain", 10);  # Start damage every 10 seconds
        quest::settimer("drain_message", 10);  # Start message every 10 seconds (sync with damage)
        
        # Send an initial message when combat begins
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "You are burned by the intense heat of the Fiendfyre Wisp!");
        }
        
        # Wait 1 second before applying the initial damage
        quest::settimer("initial_damage", 1);
    }
    elsif ($combat_state == 0) {  # Combat ends
        quest::stoptimer("life_drain");  # Stop the damage timer
        quest::stoptimer("drain_message");  # Stop the message timer
        quest::stoptimer("initial_damage");  # Stop the initial damage timer
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        # Apply 20000 damage to players, bots, pets, and bot pets every 10 seconds
        ApplyDamageToEntities();
    }
    elsif ($timer eq "drain_message") {
        # Display a message every 10 seconds to remind players
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "You are burned by the intense heat of the Fiendfyre Wisp!");
        }
    }
    elsif ($timer eq "initial_damage") {
        # Apply the initial damage after a 1 second delay to ensure all are in range
        ApplyDamageToEntities();
        quest::stoptimer("initial_damage");  # Stop the initial damage timer after the first application
    }
}

# Subroutine to apply 20000 damage to entities (players, bots, pets, bot pets)
sub ApplyDamageToEntities {
    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();
    my $radius = 50;  # Radius in units around the NPC (adjust as necessary)

    # Apply 20000 damage to players within the radius
    foreach my $entity ($entity_list->GetClientList()) {
        my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
        if ($distance <= $radius) {
           # quest::shout("Applying 20000 damage to player: $entity");  # Debugging line (shout)
            $entity->Damage($npc, 20000, 0, 1, 0);  # Apply 20000 damage to player
        }
    }

    # Apply 20000 damage to bots within the radius
    foreach my $bot ($entity_list->GetBotList()) {
        my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
        if ($distance <= $radius) {
          #  quest::shout("Applying 20000 damage to bot: $bot");  # Debugging line (shout)
            $bot->Damage($npc, 20000, 0, 1, 0);  # Apply 20000 damage to bot
        }
    }

    # Apply 20000 damage to pets within the radius
    foreach my $entity ($entity_list->GetClientList()) {
        my $pet = $entity->GetPet();  # Get the pet of the player
        if ($pet) {
            my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
           #     quest::shout("Applying 20000 damage to pet: $pet");  # Debugging line (shout)
                $pet->Damage($npc, 20000, 0, 1, 0);  # Apply 20000 damage to pet
            }
        }
    }

    # Apply 20000 damage to bot pets within the radius
    foreach my $bot ($entity_list->GetBotList()) {
        my $pet = $bot->GetPet();  # Get the pet of the bot
        if ($pet) {
            my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
              #  quest::shout("Applying 20000 damage to bot pet: $pet");  # Debugging line (shout)
                $pet->Damage($npc, 20000, 0, 1, 0);  # Apply 20000 damage to bot pets
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1776, 6); 
}
