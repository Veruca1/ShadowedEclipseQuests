sub EVENT_DEATH_COMPLETE {
quest::shout("If you admit defeat now, Zarrin will provide a swift death!");
#resets timer
quest::signalwith(1466, 101);
}