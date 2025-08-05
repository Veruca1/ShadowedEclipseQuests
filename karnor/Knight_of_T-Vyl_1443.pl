sub EVENT_DEATH {
    # When NPC 1443 dies, send a signal to NPC 1425 with a delay of 3 seconds
    quest::signalwith(1425, 1, 3);  # Signal 1 to NPC 1425 after 3 seconds
}
