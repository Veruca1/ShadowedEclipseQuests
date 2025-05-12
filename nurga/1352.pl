# NPC 1352 Script

# Variables to store signal states for first set (1, 2, 3, 4)
my $signal1 = 0;
my $signal2 = 0;
my $signal3 = 0;
my $signal4 = 0;

# Variables to store signal states for second set (5, 6, 7, 8)
my $signal5 = 0;
my $signal6 = 0;
my $signal7 = 0;
my $signal8 = 0;

# Variables to store signal states for third set (9, 10, 11, 12)
my $signal9 = 0;
my $signal10 = 0;
my $signal11 = 0;
my $signal12 = 0;

# Variables to store signal states for final set (13, 14, 15, 16)
my $signal13 = 0;
my $signal14 = 0;
my $signal15 = 0;
my $signal16 = 0;

# Variables for final signals (17, 18, 19, 20)
my $signal17 = 0;
my $signal18 = 0;
my $signal19 = 0;
my $signal20 = 0;

sub EVENT_SIGNAL {
    # Track signals 1, 2, 3, and 4
    if ($signal == 1) {
        $signal1 = 1;
    }
    elsif ($signal == 2) {
        $signal2 = 1;
    }
    elsif ($signal == 3) {
        $signal3 = 1;
    }
    elsif ($signal == 4) {
        $signal4 = 1;
    }

    # Check if all signals (1, 2, 3, and 4) have been received
    if ($signal1 == 1 && $signal2 == 1 && $signal3 == 1 && $signal4 == 1) {
        # Trigger screen shake for Boss 1 spawn
        $npc->CameraEffect(3000, 6); # 3000ms screen shake

        # Shout message
        quest::shout("Do you really think your efforts can stop Chronomancer Zarrin from changing the timeline?");
        
        # Set a 5-second timer before spawning Boss 1
        quest::settimer("spawn_boss_1", 5);
        
        # Reset signals for future use
        $signal1 = 0;
        $signal2 = 0;
        $signal3 = 0;
        $signal4 = 0;
    }

    # Track signals 5, 6, 7, and 8
    if ($signal == 5) {
        $signal5 = 1;
    }
    elsif ($signal == 6) {
        $signal6 = 1;
    }
    elsif ($signal == 7) {
        $signal7 = 1;
    }
    elsif ($signal == 8) {
        $signal8 = 1;
    }

    # Check if all signals (5, 6, 7, and 8) have been received
    if ($signal5 == 1 && $signal6 == 1 && $signal7 == 1 && $signal8 == 1) {
        # Trigger screen shake for the next wave
        $npc->CameraEffect(3000, 6); # 3000ms screen shake

        # Shout message
        quest::shout("On and on and on the struggle goes, and where does it get you?");
        
        # Set a 10-second timer before spawning the next wave of NPCs
        quest::settimer("spawn_next_wave", 10);
        
        # Reset signals for future use
        $signal5 = 0;
        $signal6 = 0;
        $signal7 = 0;
        $signal8 = 0;
    }

    # Track signals 9, 10, 11, and 12
    if ($signal == 9) {
        $signal9 = 1;
    }
    elsif ($signal == 10) {
        $signal10 = 1;
    }
    elsif ($signal == 11) {
        $signal11 = 1;
    }
    elsif ($signal == 12) {
        $signal12 = 1;
    }

    # Check if all signals (9, 10, 11, and 12) have been received
    if ($signal9 == 1 && $signal10 == 1 && $signal11 == 1 && $signal12 == 1) {
        # Trigger screen shake and shout for Boss 2 spawn
        $npc->CameraEffect(3000, 6); # 3000ms screen shake

        # Shout message
        quest::shout("Give up now, retire, and spend your days fishing at Lake Rathe!");
        
        # Set a 10-second timer before spawning Boss 2 (NPC 107156)
        quest::settimer("spawn_boss_2", 10);
        
        # Reset signals for future use
        $signal9 = 0;
        $signal10 = 0;
        $signal11 = 0;
        $signal12 = 0;
    }

    # Track signals 13, 14, 15, and 16
    if ($signal == 13) {
        $signal13 = 1;
    }
    elsif ($signal == 14) {
        $signal14 = 1;
    }
    elsif ($signal == 15) {
        $signal15 = 1;
    }
    elsif ($signal == 16) {
        $signal16 = 1;
    }

    # Check if all signals (13, 14, 15, and 16) have been received
    if ($signal13 == 1 && $signal14 == 1 && $signal15 == 1 && $signal16 == 1) {
        # Trigger screen shake for final NPCs
        $npc->CameraEffect(3000, 6); # 3000ms screen shake

        # Shout message
        quest::shout("You're wasting your time! There is no turning back now!");

        # Set a 5-second timer before spawning the final set of NPCs
        quest::settimer("spawn_final_npcs", 5);

        # Reset signals for future use
        $signal13 = 0;
        $signal14 = 0;
        $signal15 = 0;
        $signal16 = 0;
    }

    # Track final signals 17, 18, 19, and 20
    if ($signal == 17) {
        $signal17 = 1;
    }
    elsif ($signal == 18) {
        $signal18 = 1;
    }
    elsif ($signal == 19) {
        $signal19 = 1;
    }
    elsif ($signal == 20) {
        $signal20 = 1;
    }

    # Check if all final signals have been received
    if ($signal17 == 1 && $signal18 == 1 && $signal19 == 1 && $signal20 == 1) {
        # Trigger final screen shake and shout
        $npc->CameraEffect(3000, 6); # 3000ms screen shake
        quest::shout("Very well, have it your way then!");

        # Set a 15-second timer before spawning final boss NPC 1353
        quest::settimer("spawn_final_boss", 15);

        # Reset final signals for future use
        $signal17 = 0;
        $signal18 = 0;
        $signal19 = 0;
        $signal20 = 0;
    }

    # Special check for signal 50
    if ($signal == 50) {
        quest::settimer("signal_50_response", 5);  # Wait 5 seconds before the shout
    }
}

sub EVENT_TIMER {
    # When the timer completes, spawn Boss 1 (NPC 107157)
    if ($timer eq "spawn_boss_1") {
        quest::spawn2(107157, 0, 0, -936.16, -1538.91, -222.65, 263.75);
        quest::stoptimer("spawn_boss_1");
    }

    # When the timer completes, spawn the next wave of NPCs
    if ($timer eq "spawn_next_wave") {
        quest::spawn2(107004, 0, 0, -907.67, -1589.01, -222.65, 460.25);  # Spawn 107004
        quest::spawn2(107005, 0, 0, -897.09, -1543.35, -222.65, 358.75);  # Spawn 107005
        quest::spawn2(107006, 0, 0, -972.17, -1516.91, -222.65, 182.25);  # Spawn 107006
        quest::spawn2(107007, 0, 0, -1005.39, -1560.05, -222.65, 123.50);  # Spawn 107007
        quest::stoptimer("spawn_next_wave");
    }

    # When the timer completes, spawn Boss 2 (NPC 107156)
    if ($timer eq "spawn_boss_2") {
        quest::spawn2(107156, 0, 0, -986.47, -1531.19, -222.65, 69.25);
        quest::stoptimer("spawn_boss_2");
    }

    # When the timer completes, spawn the final set of NPCs
    if ($timer eq "spawn_final_npcs") {
        quest::spawn2(107017, 0, 0, -907.67, -1589.01, -222.65, 460.25);  # Spawn 107017
        quest::spawn2(107018, 0, 0, -897.09, -1543.35, -222.65, 358.75);  # Spawn 107018
        quest::spawn2(107019, 0, 0, -972.17, -1516.91, -222.65, 182.25);  # Spawn 107019
	quest::spawn2(107020, 0, 0, -1005.39, -1560.05, -222.65, 123.50);  # Spawn 107020
        quest::stoptimer("spawn_final_npcs");
    }

    # When the timer completes, spawn the final boss NPC 1353
    if ($timer eq "spawn_final_boss") {
        quest::spawn2(1353, 0, 0, -995.47, -1535.12, -222.65, 23.75);
        quest::stoptimer("spawn_final_boss");
    }

    # Handle the delayed response to signal 50
    if ($timer eq "signal_50_response") {
        quest::shout("Even if you do stop the Chronomancer, well (chuckles), no spoilers now. Hehehahahaha!");
        quest::stoptimer("signal_50_response");
    }
}
