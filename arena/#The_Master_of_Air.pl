sub EVENT_DEATH_COMPLETE {
quest::shout("Each elemental death gives you more time, hurry stop him!");
#resets timer
quest::signalwith(1232, 101);
}