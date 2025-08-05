sub EVENT_DEATH_COMPLETE {
    # Sends signal 2 to NPC 1455 with a 2-second delay
    quest::signalwith(1455, 2, 2);
}