sub EVENT_SPAWN {
    # Spawns NPC 1455 at the specified location with a given heading (change the heading if needed)
    quest::spawn2(1455, 0, 0, -32.49, -256.52, -120.27, 0);
    quest::spawn2(502004, 0, 0, -32.49, -256.52, -120.28, 0);
}

sub EVENT_DEATH_COMPLETE {
    # Sends signal 1 to NPC 1455 with a 2-second delay
    quest::signalwith(1455, 1, 2);
}
