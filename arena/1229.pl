sub EVENT_AGGRO {
    # Initialize the wave counter
    $wave_counter = 1;
    # Spawn the initial NPC
    quest::spawn2(72081, 0, 0, $x, $y, $z, $h);
    # Set up a timer for spawning waves
    quest::settimer("spawn_waves", 30);
}

sub EVENT_TIMER {
    if ($timer eq "spawn_waves") {
        # Spawn NPCs in waves
        for (my $i = 1; $i <= $wave_counter; $i++) {
            quest::spawn2(72081, 0, 0, $x + rand(10), $y + rand(10), $z, $h);
        }
        # Increase the wave counter for the next wave
        $wave_counter++;
    }
}

sub EVENT_DEATH {
    # Send a signal to NPC ID 77027
    quest::signalwith(77027,3,2);
    # Stop the spawn timer
    quest::stoptimer("spawn_waves");
}
