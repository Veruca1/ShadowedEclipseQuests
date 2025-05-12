sub EVENT_SPAWN {
    # Check if NPC 1752 is already up before spawning it
    if (!quest::isnpcspawned(1752)) {
        # Spawn NPC 1752 at the specified location
        quest::spawn2(1752, 0, 0, -3048.88, -2924.00, 43.48, 68.00);
    }
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Wait 10 seconds, then spawn NPC 1833 at the same location
        quest::settimer("spawn_npc_1833", 10);
    }
    elsif ($signal == 2) {
        # Wait 2 minutes (120 seconds) before spawning NPC 1752
        quest::settimer("spawn_npc_1752_delay", 120);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc_1833") {
        quest::stoptimer("spawn_npc_1833");
        # Spawn NPC 1833 at the specified location
        quest::spawn2(1833, 0, 0, -3048.88, -2924.00, 43.48, 68.00);
        
        # Spawn additional NPCs
        #quest::spawn2(1753, 0, 0, -3047.27, -2965.28, 26.30, 68.00);
        #quest::spawn2(1753, 0, 0, -3069.02, -2887.61, 26.30, 140.75);
    }
    elsif ($timer eq "spawn_npc_1752_delay") {
        quest::stoptimer("spawn_npc_1752_delay");
        # Check if NPC 1752 is still not spawned and then spawn it
        if (!quest::isnpcspawned(1752)) {
            quest::spawn2(1752, 0, 0, -3048.88, -2924.00, 43.48, 68.00);
        }
    }
}