sub EVENT_SPAWN {
    quest::shout("Blood-traitors and mudblood sympathizers? Disgusting. Time to cleanse this filth!");
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1776, 9); 
}