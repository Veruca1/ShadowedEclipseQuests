sub EVENT_SIGNAL {
    if ($signal == 1) {
        quest::settimer("spawn_npc", 10);  # Start a timer for 10 seconds
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc") {
        quest::spawn2(1503, 0, 0, 420.12, 802.66, 205.63, 384.50);  # Spawn NPC 1503 at the specified location
        quest::stoptimer("spawn_npc");  # Stop the timer to prevent continuous spawning
    }
}
