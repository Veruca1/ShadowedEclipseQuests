# Flags to prevent multiple spawns
my $drelzna_spawned = 0;
my $najena_spawned = 0;
my $puppets_spawned = 0;

sub EVENT_SPAWN {
  quest::setnexthpevent(75); # Set first health event at 75% health
  quest::modifynpcstat("hp", 100000); # Set initial HP (adjust as needed)
  quest::shout("Hehehehehehooooo! Well well well, who wants to be my new puppet now?"); # New shout on spawn
}

sub EVENT_HP {
  if ($hpevent == 75) {
    # Spawn minion puppets at 75% health
    if (!$puppets_spawned) {
      quest::shout("Arise my puppets!");
      quest::spawn2(44146, 0, 0, $x, $y, $z, $h); # Spawn puppet 1
      quest::spawn2(44147, 0, 0, $x, $y, $z, $h); # Spawn puppet 2
      $puppets_spawned = 1; # Set flag to prevent multiple spawns
    }
    quest::setnexthpevent(50); # Set next health event at 50% health
  }
  elsif ($hpevent == 50) {
    # Spawn Fabled Drelzna at 50% health
    if (!$drelzna_spawned) {
      quest::shout("Here is one of my favorite puppets, I'm sure you'll agree, shes to die for!");
      quest::spawn2(44105, 0, 0, $x, $y, $z, $h); # Spawn Fabled Drelzna
      $drelzna_spawned = 1; # Set flag to prevent multiple spawns
    }
    quest::setnexthpevent(20); # Set next health event at 20% health
  }
  elsif ($hpevent == 20) {
    # Spawn Fabled Najena at 20% health
    if (!$najena_spawned) {
      quest::shout("Behold! The true master of this realm on my side!");
      quest::spawn2(1226, 0, 0, $x, $y, $z, $h); # Spawn Fabled Najena
      $najena_spawned = 1; # Set flag to prevent multiple spawns
    }
  }
}

sub EVENT_COMBAT {
  if ($combat_state == 1) {
    quest::shout("You must not be allowed to proceed any further!");
  }
}
