sub EVENT_SPAWN {
  # Shout in red color when the NPC spawns
  quest::shout("I am here master, let me give you my burning flames!");

  # Spawn two initial elementals when the NPC spawns
  quest::spawn2(203376, 0, 0, $x + 5, $y, $z, $h);  # First elemental
  quest::spawn2(203376, 0, 0, $x - 5, $y, $z, $h);  # Second elemental

  # Set a timer to check combat state regularly
  quest::settimer("check_combat", 5);
}

sub EVENT_COMBAT {
  if ($combat_state == 1) {  # NPC is in combat
    quest::settimer("spawn_elementals", 8);  # Start spawning elementals every 8 seconds
    quest::settimer("shout_message", 30);    # Start shouting messages every 30 seconds
    quest::stoptimer("idle_cleanup");        # Stop the idle cleanup timer
  } else {  # NPC is out of combat
    quest::settimer("idle_cleanup", 10);     # Start idle cleanup timer for 10 seconds
    quest::stoptimer("spawn_elementals");    # Stop spawning elementals
    quest::stoptimer("shout_message");       # Stop shouting messages
  }
}

sub EVENT_TIMER {
  if ($timer eq "spawn_elementals") {
    # Spawn elementals every 8 seconds during combat
    quest::spawn2(203376, 0, 0, $x, $y, $z, $h);  # Spawn elemental at the NPC's current location
  } elsif ($timer eq "shout_message") {
    # Shout the message every 30 seconds
    quest::shout("I am here master, let me give you my burning flames!");
  } elsif ($timer eq "idle_cleanup") {
    # Depop all elementals when idle for 10 seconds
    quest::depopall(203376);  # Replace 203376 with the elemental NPC ID
    quest::stoptimer("idle_cleanup");  # Stop the idle cleanup timer
  }
}

sub EVENT_DEATH_COMPLETE {
  # Stop all timers when the NPC dies
  quest::stoptimer("spawn_elementals");
  quest::stoptimer("shout_message");
  quest::stoptimer("idle_cleanup");
}
