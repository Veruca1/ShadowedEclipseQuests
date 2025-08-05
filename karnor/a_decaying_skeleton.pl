sub EVENT_DEATH_COMPLETE {
    # Immediately send signal 1 to NPC ID 1427
    quest::signalwith(1427, 1, 2);
}
