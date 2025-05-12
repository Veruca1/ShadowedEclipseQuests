sub EVENT_DEATH_COMPLETE {
    # Send a signal to NPC 1427
    quest::signalwith(1427, 1, 0);

    my $npc_id = 44118;

    # Check if NPC 44118 is already up
    if (!quest::isnpcspawned($npc_id)) {
        # If NPC 44118 is not up, spawn it at the specified location
        quest::spawn2($npc_id, 0, 0, 456.66, -56.66, 4.51, 143);
    }
}
