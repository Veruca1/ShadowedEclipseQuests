sub EVENT_SPAWN {
    # Start a 30-minute timer named "depop" for this NPC
    quest::settimer("depop", 1800);  # 1800 seconds = 30 minutes

    # Spawn NPC 1352 (the signal NPC) at the current location
    quest::spawn2(1352, 0, 0, $x, $y, $z, $h);  # Spawn 1352 at this NPC's coordinates

    # Make sure 1352 does not despawn by setting it to never despawn
    quest::signalwith(1352, 99, 0);  # Send a signal to ensure 1352 stays active
}

sub EVENT_TIMER {
    # Check if the timer "depop" has completed
    if ($timer eq "depop") {
        quest::depop();  # Depop the NPC if the timer reaches 30 minutes
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has entered combat, stop the depop timer
        quest::stoptimer("depop");
    } elsif ($combat_state == 0) {
        # NPC has left combat, reset the depop timer
        quest::settimer("depop", 1800);
    }
}
