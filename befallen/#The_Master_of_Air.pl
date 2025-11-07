sub EVENT_DEATH_COMPLETE {
quest::shout("Each elemental death gives you more time, hurry stop him!");
#resets timer
quest::signalwith(36126, 101);
}