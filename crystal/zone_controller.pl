sub EVENT_SPAWN {
    # Initial spawn logic for other NPCs
    spawn_npc();
    spawn_additional_npc();

    # Start the zone boss spawn logic
    spawn_zone_boss();
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Start a 5-minute timer to respawn the NPC
        quest::settimer("respawn_npc", 300); # 300 seconds = 5 minutes
    }
    if ($signal == 2) {
        # Start a 5-minute timer to spawn additional NPC
        quest::settimer("respawn_additional_npc", 300); # 300 seconds = 5 minutes
    }
    if ($signal == 3) {
        # Restart the variance timer for the zone boss
        reset_zone_boss_timer();
    }
}

sub EVENT_TIMER {
    if ($timer eq "respawn_npc") {
        # Execute spawn logic again
        spawn_npc();
        quest::stoptimer("respawn_npc");
    }
    if ($timer eq "respawn_additional_npc") {
        # Execute additional spawn logic
        spawn_additional_npc();
        quest::stoptimer("respawn_additional_npc");
    }
    if ($timer eq "spawn_zone_boss_timer") {
        # Spawn the zone boss after the variance timer expires
        spawn_zone_boss();
        quest::stoptimer("spawn_zone_boss_timer");
    }
}

sub spawn_npc {
    # Define the spawn location
    my $x = -275.83;
    my $y = -241.30;
    my $z = -540.85;
    my $heading = 22;

    # Generate a random number between 0 and 100
    my $chance = int(rand(100)) + 1;

    # 25% chance to spawn NPC 1657, otherwise spawn NPC 1658
    if ($chance <= 25) {
        quest::spawn2(1657, 0, 0, $x, $y, $z, $heading); # Spawn NPC ID 1657
    } else {
        quest::spawn2(1658, 0, 0, $x, $y, $z, $heading); # Spawn NPC ID 1658
    }
}

sub spawn_additional_npc {
    # Define the spawn location for the additional NPC
    my $x = -951.00;
    my $y = -592.00;
    my $z = -534.90;
    my $heading = 124.00;

    # Generate a random number between 0 and 100
    my $chance = int(rand(100)) + 1;

    # 25% chance to spawn NPC 121072, otherwise spawn NPC 1659
    if ($chance <= 25) {
        quest::spawn2(121072, 0, 0, $x, $y, $z, $heading); # Spawn NPC ID 121072
    } else {
        quest::spawn2(1659, 0, 0, $x, $y, $z, $heading); # Spawn NPC ID 1659
    }
}

sub spawn_zone_boss {
    # Define the spawn location for the zone boss
    my $x = 318.94;
    my $y = -346.16;
    my $z = -496.95;
    my $heading = 384;

    # Check if the NPC is already spawned
    if (!quest::isnpcspawned(1660)) {
        # Spawn the zone boss
        quest::spawn2(1660, 0, 0, $x, $y, $z, $heading);

        # Set the variance timer for the next spawn (1 to 3 hours)
        reset_zone_boss_timer();
    }
}

sub reset_zone_boss_timer {
    # Generate a random number for the spawn delay (between 5 to 10 mins)
    my $spawn_delay = int(rand(300)) + 600;  # Random between 600 and 900 seconds (10 to 15 minutes)

    # Start the timer for spawning the zone boss
    quest::settimer("spawn_zone_boss_timer", $spawn_delay);
}
