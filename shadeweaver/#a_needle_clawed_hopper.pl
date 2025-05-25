sub EVENT_DEATH_COMPLETE {
    if (int(rand(100)) < 40) {
        quest::spawn2(1462, 0, 0, $x, $y, $z, $h);
    }
}