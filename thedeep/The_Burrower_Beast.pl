# Event reset logic for The Burrower Beast

sub EVENT_SPAWN {
  quest::settimer("start_controller", 300); # respawn event controller after 5 min
}

sub EVENT_TIMER {
  if ($timer eq "start_controller") {
    quest::spawn2(164120, 0, 0, 1627, 289, -54, 0); # The controller
    quest::stoptimer("start_controller");
  }
}

sub EVENT_SIGNAL {
  if ($signal == 101) { # Failure
    quest::settimer("start_controller", 300);
    quest::signalwith(164118, 102, 0); # A_rock_burrower
    quest::signalwith(164104, 102, 0); # A_spined_rock_burrower
    quest::signalwith(164100, 102, 0); # A_stone_carver
    quest::signalwith(164108, 102, 0); # A_core_burrower
    quest::signalwith(164085, 102, 0); # A_parasite_larva
  }
  elsif ($signal == 201) { # Success
    quest::depop_withtimer();
  }
}