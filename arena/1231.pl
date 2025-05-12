sub EVENT_SPAWN {
    quest::settimer("shout1", 3); # Set timer for the first shout
}

sub EVENT_TIMER {
    if ($timer eq "shout1") {
        quest::shout("I did the Monster mash. Wait, that didn't sound good");
        quest::stoptimer("shout1"); # Stop the shout1 timer to prevent looping
        quest::settimer("shout2", 7); # Set timer for the next shout
    }
    elsif ($timer eq "shout2") {
        quest::shout("Noooo no it's fine");
        quest::stoptimer("shout2"); # Stop the shout2 timer after the second shout
	quest::shout("Seriously though, try to defeat me first as defeating Monster starts the timer for the next wave!");
    }
}
