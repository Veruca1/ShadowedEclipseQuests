# Burrower Beast event controller

sub EVENT_SPAWN {
  $x = $npc->GetX();
  $y = $npc->GetY();
  quest::set_proximity($x - 50, $x + 50, $y - 50, $y + 50);
}

sub EVENT_ENTER {
  quest::settimer("wave1", 0);        # Immediately
  quest::settimer("wave2", 90);      # 1.5 mins
  quest::settimer("wave3", 180);      # 3 mins
  quest::settimer("wave4", 270);      # 4.5 mins (boss)
  quest::emote("The ground around you begins to tremble and shake.");
  quest::clear_proximity();
}

sub EVENT_TIMER {
  if ($timer eq "wave1") {
    spawn_wave(164118, 3, 6); # Rock burrowers
  } elsif ($timer eq "wave2") {
    spawn_wave(1950, 3, 6); # Spined burrowers
  } elsif ($timer eq "wave3") {
    spawn_wave(1951, 3, 6); # Stone carvers
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
    my $x = 1700 + int(rand(150));   # narrowed from 1650-1950 to 1700-1850
    my $y = 200 + int(rand(100));   # narrowed from 150-450 to 200-300
    my $z = -25 + int(rand(10));    # narrowed from -30 to -10 to -25 to -15
    my $h = int(rand(256));
    quest::spawn2($mob_id, 0, 0, $x, $y, $z, $h);
  }
}

sub EVENT_SIGNAL {
  if ($signal == 10) {
    quest::depop();
  }
}