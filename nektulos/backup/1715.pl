sub EVENT_DEATH_COMPLETE {
    # Send signal 2 to NPC ID 10 upon death
    quest::signalwith(10, 2);
}