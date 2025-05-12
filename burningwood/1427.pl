my $count = 0;  # Initialize a count variable

sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Wait 10 seconds (10,000 milliseconds) for signal 1
        quest::settimer("spawn_npc_1489", 10);
    }
    elsif ($signal == 2) {
        # Wait 10 seconds (10,000 milliseconds) for signal 2
        quest::settimer("spawn_npc_1490", 10);
    }
    elsif ($signal == 3) {
        $count++;  # Increment count for signal 3
        if ($count == 2) {
            # When count reaches 2, do the action for signal 3
            quest::settimer("spawn_npc_1491", 10);
            $count = 0;  # Reset count after reaching 2
        }
    }
    elsif ($signal == 4) {
        $count++;  # Increment count for signal 4
        if ($count == 3) {
            # When count reaches 3, spawn NPC ID 1492 at the specified location
            quest::settimer("spawn_npc_1492", 10);
            $count = 0;  # Reset count after reaching 3
        }
    }
    elsif ($signal == 5) {
        # Start a 5-second timer for signal 5
        quest::settimer("spawn_npc_1493", 5);
    }
    elsif ($signal == 6) {
        # Start a 5-second timer for signal 6
        quest::settimer("spawn_npc_1494", 5);
    }
    elsif ($signal == 7) {
        $count++;  # Increment count for signal 7
        if ($count == 2) {
            # When count reaches 2, set a 5-second timer to spawn NPC 1495
            quest::settimer("spawn_npc_1495", 5);
            $count = 0;  # Reset count after reaching 2
        }
    }
    elsif ($signal == 8) {
        $count++;  # Increment count for signal 8
        if ($count == 3) {
            # When count reaches 3, set a 5-second timer to spawn NPC 1496
            quest::settimer("spawn_npc_1496", 5);
            $count = 0;  # Reset count after reaching 3
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc_1489") {
        quest::spawn2(1489, 0, 0, -210.39, -208.70, -372.32, 200.25);
        quest::stoptimer("spawn_npc_1489");
    }
    elsif ($timer eq "spawn_npc_1490") {
        quest::spawn2(1490, 0, 0, -202.98, -196.67, -373.43, 177.75);
        quest::spawn2(1490, 0, 0, -212.66, -228.80, -373.37, 177.75);
        quest::stoptimer("spawn_npc_1490");
    }
    elsif ($timer eq "spawn_npc_1491") {
        quest::spawn2(1491, 0, 0, -210.39, -208.70, -372.32, 200.25);
        quest::spawn2(1491, 0, 0, -202.98, -196.67, -373.43, 177.75);
        quest::spawn2(1491, 0, 0, -212.66, -228.80, -373.37, 177.75);
        quest::stoptimer("spawn_npc_1491");
    }
    elsif ($timer eq "spawn_npc_1492") {
        quest::spawn2(1492, 0, 0, -210.39, -208.70, -372.32, 200.25);
        quest::stoptimer("spawn_npc_1492");
    }
    elsif ($timer eq "spawn_npc_1493") {
        quest::spawn2(1493, 0, 0, -210.39, -208.70, -372.32, 200.25);
        quest::stoptimer("spawn_npc_1493");
    }
    elsif ($timer eq "spawn_npc_1494") {
        quest::spawn2(1494, 0, 0, -202.98, -196.67, -373.43, 177.75);
        quest::spawn2(1494, 0, 0, -212.66, -228.80, -373.37, 177.75);
        quest::stoptimer("spawn_npc_1494");
    }
    elsif ($timer eq "spawn_npc_1495") {
        quest::spawn2(1495, 0, 0, -210.39, -208.70, -372.32, 200.25);
        quest::spawn2(1495, 0, 0, -202.98, -196.67, -373.43, 177.75);
        quest::spawn2(1495, 0, 0, -212.66, -228.80, -373.37, 177.75);
        quest::stoptimer("spawn_npc_1495");
    }
    elsif ($timer eq "spawn_npc_1496") {
        my $npc_id = 1496;
        # Check if NPC 1496 is already spawned
        if (!quest::isnpcspawned($npc_id)) {
            quest::spawn2($npc_id, 0, 0, -210.39, -208.70, -372.32, 200.25);
        }
        quest::stoptimer("spawn_npc_1496");
    }
}
