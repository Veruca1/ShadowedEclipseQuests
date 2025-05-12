sub EVENT_DEATH_COMPLETE {
    # Send signal 2 to NPC 1427 after a 2-second delay
    quest::signalwith(1427, 2, 2);
}