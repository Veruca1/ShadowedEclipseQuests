# NPC 107002 Script

sub EVENT_DEATH_COMPLETE {
    # Send signal 1 to NPC 1352
    quest::signalwith(1352, 7, 2);
}
