sub EVENT_DEATH_COMPLETE {
    # Send a signal with value 4 to NPC ID 2000107, with a delay of 2 seconds
    quest::signalwith(1423, 4, 2);
}