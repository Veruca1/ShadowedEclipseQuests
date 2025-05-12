sub EVENT_SPAWN {
    # Start a 30-minute timer named "depop"
    quest::settimer("depop", 1800);  # 1800 seconds = 30 minutes
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
