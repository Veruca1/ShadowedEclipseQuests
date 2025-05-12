sub EVENT_DEATH_COMPLETE {
    # On death, send a signal to NPC ID 10
    quest::signalwith(10, 1, 0); # Signal NPC ID 10 with signal value 1
}