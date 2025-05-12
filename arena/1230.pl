sub EVENT_SPAWN {
    quest::shout("He did the mash");
    quest::settimer("shout2", 10); # Set timer for the next shout
}

sub EVENT_TIMER {
    if ($timer eq "shout2") {
        quest::shout("Not that there's anything wrong with that!");
        quest::stoptimer("shout2"); # Stop the timer to prevent looping
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(77027,4,2); # Notify NPC with ID 77027 with a 2-second delay when NPC 1230 dies
}
