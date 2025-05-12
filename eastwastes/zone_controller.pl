sub EVENT_SPAWN {
    # Existing logic: 25% chance to spawn NPC ID 1646, otherwise spawn 116069
    if (int(rand(100)) < 25) {
        quest::spawn2(1646, 0, 0, 3446.00, -1503.00, 172.60, 316.00);
    } else {
        quest::spawn2(116069, 0, 0, 3446.00, -1503.00, 172.60, 316.00);
    }

    # Start a 3-hour timer to periodically check and spawn NPCs if not up
    quest::settimer("check_spawn", 10800);
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Existing logic: Start a 5-minute timer to redo the spawn logic
        quest::settimer("respawn_event", 300);
    }
}

sub EVENT_TIMER {
    if ($timer eq "respawn_event") {
        # Existing logic: Stop the timer and re-run EVENT_SPAWN logic
        quest::stoptimer("respawn_event");
        EVENT_SPAWN();
    } elsif ($timer eq "check_spawn") {
        # New logic: Check if NPCs 1646 or 116069 are up and spawn them if not
        if (!quest::isnpcspawned(1646)) {
            quest::spawn2(1646, 0, 0, 3446.00, -1503.00, 172.60, 316.00);
        }
        if (!quest::isnpcspawned(116069)) {
            quest::spawn2(116069, 0, 0, 3446.00, -1503.00, 172.60, 316.00);
        }
    }
}
