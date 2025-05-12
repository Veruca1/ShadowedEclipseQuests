sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 3); # Sends signal 3 to zone_controller with NPC ID 10
}
