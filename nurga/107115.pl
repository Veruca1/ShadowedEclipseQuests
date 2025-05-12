# NPC 107112 Script

sub EVENT_DEATH_COMPLETE {
    # Send signal 4 to NPC 1352 with a 2-second delay
    quest::signalwith(1352, 15, 2);
}
