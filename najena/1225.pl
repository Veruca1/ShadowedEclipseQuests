sub EVENT_SPAWN {
    # Define waypoints and corresponding headings
    @waypoints = (
        [-174.21, -81.87, -25.50, 258.75],
        [-174.61, -19.33, -25.50, 259.75],
        [-123.77, -18.12, -25.50, 132.50],
        [-60.79, -7.41, -25.50, 263.75],
        [-71.31, -84.67, -25.20, 384.75]
    );
    
    $current_wp = 0; # Initialize the current waypoint index
    quest::settimer("movement", 1); # Start the movement timer
}

sub EVENT_TIMER {
    if ($timer eq "movement") {
        # Stop the timer to avoid multiple triggers
        quest::stoptimer("movement");
        
        # Move NPC to the next waypoint
        if ($current_wp < scalar(@waypoints)) {
            my ($x, $y, $z, $h) = @{$waypoints[$current_wp]};
            $npc->MoveTo($x, $y, $z, $h, 1); # Walk to the next waypoint
        } else {
            $current_wp = 0; # Reset waypoint index and loop back to start
            quest::settimer("movement", 5); # Restart the movement timer
        }
    }
}

sub EVENT_WAYPOINT_ARRIVE {
    # Actions upon arriving at a waypoint
    if ($current_wp == 1) {
        quest::emote("arrives at another part of its cellblock.");
    } elsif ($current_wp == 4) {
        quest::emote("whispers softly as it moves forward.");
    }
    
    # Move to the next waypoint index and set the movement timer
    $current_wp++;
    quest::settimer("movement", 5); # Set a 5-second pause timer
}
