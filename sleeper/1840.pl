sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 1);  # Sends signal to NPC with ID 10, with signal value 1
}