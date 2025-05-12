sub EVENT_SPAWN {
    quest::shout("This ends now, Voldemort!");
    quest::settimer("depop", 120);  # Set a timer to depop in 120 seconds (2 minutes)
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::depop();  # Depop the NPC after 2 minutes
    }
}
