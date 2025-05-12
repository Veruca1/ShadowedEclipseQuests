sub EVENT_AGGRO {
    quest::signalwith(10, 2);  # Send signal 2 to zone_controller to stop the cycle
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 3);  # Send signal 3 to zone_controller to restart the cycle
}
