sub EVENT_SPAWN {
    quest::shout("Surely you didn't think I was going to keep my filthy Muggle father's name?");
}

sub EVENT_DEATH_COMPLETE {
    # Use quest::ChooseRandom to determine if NPC 1666 should spawn
    if (quest::ChooseRandom(1, 1, 0, 0) == 1) {
        # Check if NPC 1666 is already spawned
        if (!quest::isnpcspawned(1666)) {
            # Spawns NPC 1666 at the specified location
            quest::spawn2(1666, 0, 0, 646.38, 510.97, 23.44, 259.25);
        }
    }
}
