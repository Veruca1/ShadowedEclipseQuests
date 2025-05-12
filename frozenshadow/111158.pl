sub EVENT_DEATH_COMPLETE {
    # Generate a random number between 1 and 100
    my $chance = int(rand(100)) + 1;

    # Determine which NPC to spawn (25% chance for NPC 1640, otherwise NPC 1619)
    my $npc_id = ($chance <= 25) ? 1640 : 1619;

    # Check if the chosen NPC ID is already up
    if (!quest::isnpcspawned($npc_id)) {
        # Spawn the chosen NPC at the specified location
        quest::spawn2($npc_id, 0, 0, 330.99, 234.53, -0.17, 381.25);
    }
}