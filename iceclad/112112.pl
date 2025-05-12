sub EVENT_SPAWN {
    # Start a 10-minute timer when spawned
    quest::settimer("depop_check", 600); # 600 seconds = 10 minutes
}

sub EVENT_TIMER {
    if ($timer eq "depop_check") {
        quest::stoptimer("depop_check");
        quest::depop(); # depop Commander_Kvarid
    }
}

sub EVENT_AGGRO {
    # Cancel the depop timer if engaged in combat
    quest::stoptimer("depop_check");
}
