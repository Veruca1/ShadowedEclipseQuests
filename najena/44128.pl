sub EVENT_SPAWN {
    quest::settimer("summon_pet", 30);  # Set a timer to check for pet summoning every 30 seconds
}

sub EVENT_TIMER {
    if ($timer eq "summon_pet") {
        # Check if the pet is not already present
        my $pet_id = $npc->GetPetID();
        if (!$pet_id) {
            $npc->CastSpell(1674, $npc->GetID());  # Cast the air pet spell
        }
    }
}

sub EVENT_AGGRO {
    quest::shout("You dare challenge Xyron's Elite?");  # Debug message when NPC is aggroed
    $npc->AddToHateList($client, 1);  # Add the player to the hate list to ensure attack
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::shout("Prepare to meet your end!");  # Debug message when entering combat
    } elsif ($combat_state == 0) {
        quest::shout("Coward!");  # Debug message when leaving combat
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("The next challenge awaits...");
    if (!quest::isnpcspawned(44129)) {
        quest::spawn2(44129, 0, 0, 217.15, 289.41, 4.06, 511.00);  # Original heading value
    }
}

