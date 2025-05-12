sub EVENT_DEATH_COMPLETE {
    # Signal NPC 1343 that a priest has died
    quest::signalwith(1343, 1, 2);
}
