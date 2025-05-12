sub EVENT_SPAWN {
    quest::shout("The Dark Lord rewards loyalty—your deaths will be my tribute!");
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1776, 4); 
}