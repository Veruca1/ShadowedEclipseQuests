sub EVENT_DEATH_COMPLETE {
    # Send signal 11 to NPC ID 10 when this NPC dies
    quest::signalwith(10, 11);
}
