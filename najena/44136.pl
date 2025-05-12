sub EVENT_SPAWN {
    quest::settimer("summon_pet", 5);  # Set a timer to check for pet summoning every 5 seconds
}

sub EVENT_TIMER {
    if ($timer eq "summon_pet") {
        # Check if the pet is not already present
        my $pet_id = $npc->GetPetID();
        if (!$pet_id) {
            $npc->CastSpell(1936, $npc->GetID());  # Cast the pet spell (ID 1936)
        }
    }
}

sub EVENT_AGGRO {
    $npc->AddToHateList($client, 1);  # Add the player to the hate list to ensure attack
}

sub EVENT_COMBAT {
    # No actions on entering or leaving combat
}

sub EVENT_DEATH_COMPLETE {
    # No actions on death
}
