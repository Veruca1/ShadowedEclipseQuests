# qst/zone/2234.pl

my $spawning = 0;

sub EVENT_SIGNAL {
    if ($signal == 10 && !$spawning) {
        $spawning = 1;
        StartSpawnTimer();
    } elsif ($signal == 20) {
        $spawning = 0;
        quest::stoptimer("spawn_npc");
    }
}

sub StartSpawnTimer {
    if ($spawning) {
        my $interval = int(rand(60)) + 1;  # Random between 1 and 60 seconds
        quest::settimer("spawn_npc", $interval);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc") {
        quest::stoptimer("spawn_npc");  # Stop current timer to reset interval
        if ($spawning) {
            my $x = $npc->GetX();
            my $y = $npc->GetY();
            my $z = $npc->GetZ();
            my $h = $npc->GetHeading();
            quest::spawn2(2235, 0, 0, $x, $y, $z, $h);
            StartSpawnTimer();  # Schedule the next one
        }
    }
}