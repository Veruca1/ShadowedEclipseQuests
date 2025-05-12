sub EVENT_DEATH_COMPLETE {
    my $npc_id = 44119;

    # Check if NPC 44119 is already up
    if (!quest::isnpcspawned($npc_id)) {
        # If NPC 44119 is not up, spawn it at the specified location
        quest::spawn2($npc_id, 0, 0, 407.27, -27.55, 4.50, 169.25);
    }

    # Send a signal to NPC 1427
    quest::signalwith(1427, 1, 0);
}
