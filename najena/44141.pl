sub EVENT_SPAWN {
    quest::settimer("summon_pet", 5);  # Set a timer to check for pet summoning every 5 seconds
}

sub EVENT_TIMER {
    if ($timer eq "summon_pet") {
        # Check if the pet is not already present
        my $pet_id = $npc->GetPetID();
        if (!$pet_id) {
            my $pet = quest::spawn2(44067, 0, 0, -43.87, 5.08, 4.06, 129.00);  # Spawn the pet NPC (ID 44067) at the specified location
            my $pet_entity = $entity_list->GetNPCByID($pet);  # Get the pet entity by its NPC ID
            if ($pet_entity) {
                $npc->SetPetID($pet_entity->GetID());  # Link the pet to the master
                $pet_entity->SetOwnerID($npc->GetID());  # Set the master as the pet's owner
                if (my $target = $npc->GetHateTop()) {
                    $pet_entity->AddToHateList($target, 1);  # Sync aggro with the master
                }
            }
        }
    }
}

sub EVENT_AGGRO {
    $npc->AddToHateList($client, 1);  # Add the player to the hate list to ensure attack
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        if (my $pet_entity = $entity_list->GetNPCByNPCTypeID(44067)) {  # Get the pet entity by its NPC Type ID
            if (my $target = $npc->GetHateTop()) {
                $pet_entity->AddToHateList($target, 1);  # Sync aggro with the master
            }
        }
    } elsif ($combat_state == 0) {
        if (my $pet_entity = $entity_list->GetNPCByNPCTypeID(44067)) {  # Get the pet entity by its NPC Type ID
            $pet_entity->WipeHateList();  # Clear the pet's hate list when out of combat
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # No actions on death
}
