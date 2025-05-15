sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::signalwith(10, 250); # Notify controller that engagement started
        quest::setnexthpevent(50); # Set to trigger EVENT_HP at 50% HP
    }
}

sub EVENT_HP {
    if ($hpevent == 50) {
        my $chance = int(rand(100));
        if ($chance < 30) {
            quest::spawn2(1945, 0, 0, $x, $y, $z, $h); # Spawn first 1945
            quest::spawn2(1945, 0, 0, $x+5, $y, $z, $h); # Spawn second 1945, slightly offset
            quest::depop(); # Depop self
            quest::signalwith(10, 1002); # 1000 for 1941
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 1002); # 1000 for 1941
}