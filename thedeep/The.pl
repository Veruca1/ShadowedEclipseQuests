# Burrower Beast event controller

sub EVENT_SPAWN {
  $x = $npc->GetX();
  $y = $npc->GetY();
  quest::set_proximity($x - 50, $x + 50, $y - 50, $y + 50);
}

sub EVENT_ENTER {
  quest::settimer("wave1", 0);        # Immediately
  quest::settimer("wave2", 180);      # 3 mins
  quest::settimer("wave3", 360);      # 6 mins
  quest::settimer("wave4", 540);      # 9 mins (boss)
  quest::emote("The ground around you begins to tremble and shake.");
  quest::clear_proximity();
}

sub EVENT_TIMER {
  if ($timer eq "wave1") {
    spawn_wave(164118, 4, 6); # Rock burrowers
  } elsif ($timer eq "wave2") {
    spawn_wave(164104, 5, 6); # Spined burrowers
  } elsif ($timer eq "wave3") {
    spawn_wave(164100, 5, 6); # Stone carvers
  } elsif ($timer eq "wave4") {
    quest::spawn2(164089, 0, 0, 1780, 227, -63.1, 0); # A_burrower_parasite
    quest::depop(); # Remove controller
  }
  quest::stoptimer($timer);
}

sub spawn_wave {
  my ($mob_id, $min, $max) = @_;
  my $count = $min + int(rand($max - $min + 1)); # random in range

  for (my $i = 0; $i < $count; $i++) {
    my $x = 1650 + int(rand(300));
    my $y = 150 + int(rand(300));
    my $z = -30 + int(rand(20));
    my $h = int(rand(256));
    quest::spawn2($mob_id, 0, 0, $x, $y, $z, $h);
  }
}