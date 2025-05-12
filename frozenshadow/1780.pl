sub EVENT_SPAWN {
    quest::shout("Step forward, I promise it will be quick… or maybe not!");
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1776, 7); 
}