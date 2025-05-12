sub EVENT_DEATH_COMPLETE {
    # Send a signal (signal 1) to NPC ID 1427 with a 2-second delay
    quest::signalwith(1427, 1, 2);  # Sends signal 1 to NPC 1427 after 2 seconds
}
