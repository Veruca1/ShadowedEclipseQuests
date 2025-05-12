sub EVENT_DEATH_COMPLETE {
    my $npc_id = 1496;  # Correct NPC ID

    # Check if the NPC is already spawned
    if (!quest::isnpcspawned($npc_id)) {
        # Spawn the NPC at the specified location
        quest::spawn2($npc_id, 0, 0, -210.39, -208.70, -372.32, 200.25);
    }
}
