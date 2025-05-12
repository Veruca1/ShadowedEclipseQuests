sub EVENT_DEATH_COMPLETE {
    # Send a signal with value 5 to NPC ID 2000107, with a delay of 2 seconds
    quest::signalwith(1423, 5, 2);
}