sub EVENT_SPAWN {
    quest::settimer("depop_me", 60);
}

sub EVENT_TIMER {
    if ($timer eq "depop_me") {
        quest::stoptimer("depop_me");
        quest::depop();
    }
}
