sub EVENT_SPAWN {
    # Start a timer that will trigger after 900 seconds (15 minutes)
    quest::settimer("depop", 900);
    quest::shout("Oi! Up here!");
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::depop(); # Depop the NPC
    }
}
