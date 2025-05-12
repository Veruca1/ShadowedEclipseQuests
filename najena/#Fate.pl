sub EVENT_DEATH_COMPLETE {
    my $npc_id = 44120;

    # Check if NPC 44120 is already up
    if (!quest::isnpcspawned($npc_id)) {
        # If NPC 44120 is not up, spawn it at the specified location
        quest::spawn2($npc_id, 0, 0, 356.34, -13.78, 4.28, 162.75);
    }

    # Send a signal to NPC 1427
    quest::signalwith(1427, 1, 0);
}
