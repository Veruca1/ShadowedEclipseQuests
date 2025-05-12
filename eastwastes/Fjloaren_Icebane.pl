sub EVENT_DEATH_COMPLETE {
    # Send SIGNAL 1 to the zone controller with NPC ID 724075
    quest::signalwith(10, 1, 0); # Signal 1, no delay
}
