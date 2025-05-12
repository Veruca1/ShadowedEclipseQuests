sub EVENT_SPAWN {
    quest::settimer("summon_pet", 30);  # Set a timer to check for pet summoning every 30 seconds
}

sub EVENT_TIMER {
    if ($timer eq "summon_pet") {
        # Check if the pet is not already present
        my $pet_id = $npc->GetPetID();
        if (!$pet_id) {
            $npc->CastSpell(2557, $npc->GetID());  # Cast the familiar spell (wizard example)
        }
    }
}

sub EVENT_AGGRO {
    $npc->AddToHateList($client, 1);  # Add the player to the hate list to ensure attack
    quest::shout("You dare challenge Xyron's Elite?");  # Message when NPC is aggroed
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Entering combat actions
    } elsif ($combat_state == 0) {
        # Leaving combat actions
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("You have no idea what fresh hell you are in for!");
    if (!quest::isnpcspawned(44130)) {
        quest::spawn2(44130, 0, 0, 189.16, 48.35, -25.50, 511.25);  # Original heading value
    }
}
