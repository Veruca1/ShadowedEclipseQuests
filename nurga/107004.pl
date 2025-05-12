# NPC 107004 Script

sub EVENT_DEATH_COMPLETE {
    # Send signal 1 to NPC 1352
    quest::signalwith(1352, 9, 2);
}
