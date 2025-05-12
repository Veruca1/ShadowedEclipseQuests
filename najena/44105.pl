sub EVENT_SPAWN {
  quest::settimer("spawn_skeletons", 7); # Timer to spawn skeletons every 7 seconds
}

sub EVENT_TIMER {
  if ($timer eq "spawn_skeletons") {
    if ($npc->GetCombatState() == 1) {
      quest::shout("My sweet skeletal children, ATTACK!");
      quest::spawn2(1249, 0, 0, $x, $y, $z, $h); # Spawn skeletal children
    }
  }
}

sub EVENT_DEATH_COMPLETE {
  quest::stoptimer("spawn_skeletons"); # Stop the timer when the NPC dies
}
