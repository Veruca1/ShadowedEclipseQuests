# NPC 107110 Script

sub EVENT_DEATH_COMPLETE {
    # Send signal 2 to NPC 1352 with a 2-second delay
    quest::signalwith(1352, 2, 2);
}
