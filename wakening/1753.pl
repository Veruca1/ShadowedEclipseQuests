sub EVENT_SPAWN {
    if ($combat_state == 0) {
        quest::settimer("depop_timer", 120); # Start 2-minute countdown if not in combat
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        quest::settimer("depop_timer", 120); # Start 2-minute countdown if combat never started
    } elsif ($combat_state == 1) {
        quest::stoptimer("depop_timer"); # Stop the countdown if re-engaged
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_timer") {
        quest::depop();
        quest::signalwith(10, 2);  # Send signal to zone ID 10, with signal value 2
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 2);  # Send signal to zone ID 10, with signal value 2
}