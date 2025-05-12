sub EVENT_SPAWN {
    # Spawn NPC 1655 at the specified location
    quest::spawn2(1655, 0, 0, 2052.00, -6864.88, 187.10, 350.25);
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Generate a random time between 1 and 3 hours (3600 to 10800 seconds)
        my $random_time = int(rand(7200)) + 3600;  # Random time between 3600 (1 hour) and 10800 (3 hours)

        # Set a timer to spawn NPC 1655 after the random time
        quest::settimer("spawn_timer", $random_time);
    }
}

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        # Check if the spawn timer is active
        if (quest::hastimer("spawn_timer")) {
            # Get the remaining time in milliseconds for the "spawn_timer"
            my $remaining_time_ms = quest::getremainingtimeMS("spawn_timer");

            # Convert milliseconds to seconds
            my $remaining_time = int($remaining_time_ms / 1000);

            # Convert the remaining time to hours, minutes, and seconds
            my $hours_left = int($remaining_time / 3600);
            my $minutes_left = int(($remaining_time % 3600) / 60);
            my $seconds_left = $remaining_time % 60;

            # Report the remaining time for the next spawn using whisper
            quest::whisper("The next spawn of Frostbane's Champion is in $hours_left hours, $minutes_left minutes, and $seconds_left seconds.");
        }
        else {
            # If there's no active spawn timer, report that the spawn will happen shortly
            quest::whisper("The next spawn of Frostbane's Champion will happen shortly.");
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_timer") {
        # Spawn NPC 1655 at the specified location after the random time
        quest::spawn2(1655, 0, 0, 2052.00, -6864.88, 187.10, 350.25);

        # Optionally, reset the timer again to keep the random spawning going
        quest::settimer("spawn_timer", int(rand(7200)) + 3600);  # Reset the timer to a random time between 1 and 3 hours
    }
}
