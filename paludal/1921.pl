my $depop_timer;

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        # Start 5-minute timer when combat ends
        quest::settimer("depop_check", 300);
    } else {
        # Stop the timer if combat resumes
        quest::stoptimer("depop_check");
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_check") {
        quest::stoptimer("depop_check");
        quest::depop();
    }
}