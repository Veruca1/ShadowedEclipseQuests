# A_burrower_parasite event outcome handler

sub EVENT_SPAWN {
  quest::settimer("countdown", 1800); # 30-minute fail-safe
}

sub EVENT_TIMER {
  quest::signalwith(164098, 101, 0); # Signal failure
  quest::depop();
}

sub EVENT_DEATH_COMPLETE {
  quest::signalwith(164098, 201, 0); # Signal success
  quest::stoptimer("countdown");
}
