sub EVENT_SPAWN {
  # Set timers
  quest::settimer("check_combat", 5); # Check combat state every 5 seconds
}

sub EVENT_COMBAT {
  if ($combat_state == 1) {  # NPC is in combat
    quest::settimer("spawn_skeletons", 7);  # Start spawning skeletons every 7 seconds
    quest::settimer("shout_message", 30);   # Start shouting messages every 30 seconds
    quest::stoptimer("idle_cleanup");  # Stop the idle cleanup timer if combat resumes
  } else {  # NPC is out of combat
    quest::settimer("idle_cleanup", 10);  # Start idle cleanup timer for 10 seconds
    quest::stoptimer("spawn_skeletons");  # Stop spawning skeletons
    quest::stoptimer("shout_message");    # Stop shouting messages
  }
}

sub EVENT_TIMER {
  if ($timer eq "spawn_skeletons") {
    quest::shout("My sweet skeletal children, ATTACK!");
    quest::spawn2(1249, 0, 0, $x, $y, $z, $h);  # Spawn skeletal children
  } elsif ($timer eq "shout_message") {
    quest::shout("Master, take some of my power and grow stronger!");
  } elsif ($timer eq "idle_cleanup") {
    quest::depopall(1249);  # Depop all skeletal children when idle for 10 seconds
    quest::stoptimer("idle_cleanup");  # Stop the idle cleanup timer
  }
}

sub EVENT_DEATH_COMPLETE {
  # Stop all timers when the NPC dies
  quest::stoptimer("spawn_skeletons");
  quest::stoptimer("shout_message");
  quest::stoptimer("idle_cleanup");
  quest::depopall(1249);  # Depop all skeletal children on death
}
sub EVENT_SPAWN {
  # Set timers
  quest::settimer("check_combat", 5); # Check combat state every 5 seconds
}

sub EVENT_COMBAT {
  if ($combat_state == 1) {  # NPC is in combat
    quest::settimer("spawn_skeletons", 7);  # Start spawning skeletons every 7 seconds
    quest::settimer("shout_message", 30);   # Start shouting messages every 30 seconds
    quest::stoptimer("idle_cleanup");  # Stop the idle cleanup timer if combat resumes
  } else {  # NPC is out of combat
    quest::settimer("idle_cleanup", 10);  # Start idle cleanup timer for 10 seconds
    quest::stoptimer("spawn_skeletons");  # Stop spawning skeletons
    quest::stoptimer("shout_message");    # Stop shouting messages
  }
}

sub EVENT_TIMER {
  if ($timer eq "spawn_skeletons") {
    quest::shout("My sweet skeletal children, ATTACK!");
    quest::spawn2(1249, 0, 0, $x, $y, $z, $h);  # Spawn skeletal children
  } elsif ($timer eq "shout_message") {
    quest::shout("Master, take some of my power and grow stronger!");
  } elsif ($timer eq "idle_cleanup") {
    quest::depopall(1249);  # Depop all skeletal children when idle for 10 seconds
    quest::stoptimer("idle_cleanup");  # Stop the idle cleanup timer
  }
}

sub EVENT_DEATH_COMPLETE {
  # Stop all timers when the NPC dies
  quest::stoptimer("spawn_skeletons");
  quest::stoptimer("shout_message");
  quest::stoptimer("idle_cleanup");
  quest::depopall(1249);  # Depop all skeletal children on death
}
