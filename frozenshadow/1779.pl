sub EVENT_SPAWN {
    quest::shout("Blood demands sacrifice! I’ll show you the true meaning of execution!");
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1776, 5); 
}