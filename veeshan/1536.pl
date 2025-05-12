sub EVENT_DEATH_COMPLETE {
    # Send signal 2 to NPC 1427
    quest::signalwith(1427, 2, 1);
    quest::signalwith(1427, 3, 0);
}