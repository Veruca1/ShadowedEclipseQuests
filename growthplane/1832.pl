sub EVENT_DEATH_COMPLETE {
    # Signal NPC ID 127098 with signal 1337 when this NPC dies
    quest::signalwith(1873, 1337);
}