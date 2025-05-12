sub EVENT_SPAWN {
    # Set a 2-minute (120 seconds) timer to depop this NPC
    quest::settimer("depop", 120);  
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::depop();  # Depop the NPC after 2 minutes
    }
}