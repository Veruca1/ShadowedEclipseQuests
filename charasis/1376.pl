sub EVENT_DEATH_COMPLETE {
    # Send signal 1 to the zone_controller with NPC ID 1352
    quest::signalwith(1352, 3, 2);  
}