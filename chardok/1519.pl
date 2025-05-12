sub EVENT_COMBAT {
    # Check if NPC has entered combat
    if ($combat_state == 1) {
        # Start a repeating timer to cast the spell every 10 seconds
        quest::settimer("cast_on_players", 10);
    } else {
        # Stop the timer when combat ends
        quest::stoptimer("cast_on_players");
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_on_players") {
        # Get a list of all clients (players and bots) in the zone
        my @targets = $entity_list->GetClientList();

        # Loop through each target
        foreach my $target (@targets) {
            # Ensure the target is within a reasonable range (e.g., 100 units)
            if ($npc->CalculateDistance($target->GetX(), $target->GetY(), $target->GetZ()) <= 100) {
                # Cast spell 36945 on the target
                $npc->CastSpell(36945, $target->GetID());
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop the timer when the NPC dies
    quest::stoptimer("cast_on_players");
}
