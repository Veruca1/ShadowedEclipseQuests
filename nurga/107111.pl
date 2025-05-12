# NPC 107111 Script

sub EVENT_DEATH_COMPLETE {
    # Send signal 3 to NPC 1352 with a 2-second delay
    quest::signalwith(1352, 3, 2);
}
