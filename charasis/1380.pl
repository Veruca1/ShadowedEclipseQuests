sub EVENT_DEATH_COMPLETE {
    # Send signal 2 to the zone_controller with NPC ID 1352
    quest::signalwith(1352, 2, 2);
}