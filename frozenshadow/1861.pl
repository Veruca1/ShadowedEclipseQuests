sub EVENT_DEATH_COMPLETE {
    # Signal NPC 1851 with signal value 100 when NPC 1861 dies
    quest::signalwith(1851, 100);
}