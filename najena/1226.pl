sub EVENT_SPAWN {
  quest::settimer("spawn_elementals", 15); # Timer to spawn elementals every 15 seconds
}

sub EVENT_TIMER {
  if ($timer eq "spawn_elementals") {
    if ($npc->GetCombatState() == 1) {
      quest::shout("Elementals, Destroy them!!!!!");
      quest::spawn2(203376, 0, 0, $x, $y, $z, $h); # Spawn elementals
    }
  }
}

sub EVENT_DEATH_COMPLETE {
  quest::stoptimer("spawn_elementals"); # Stop the timer when Najena is defeated
}
