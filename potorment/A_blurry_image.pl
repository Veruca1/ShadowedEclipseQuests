# A_blurry_image.pl
# Trigger NPC - flips to a visible mob when player enters proximity

sub EVENT_SPAWN {
    quest::set_proximity($x - 50, $x + 50, $y - 50, $y + 50, $z - 50, $z + 50);
}

sub EVENT_ENTER {
    quest::depop();

    my $roll = int(rand(100));
    if ($roll < 25) {
        # 25% chance to spawn zealot
        quest::spawn2(2273, 0, 0, $x, $y, $z, $h);
    } else {
        # 50/50 between frightening and chilling
        my $pick = (int(rand(2)) == 0) ? 2274 : 2275;
        quest::spawn2($pick, 0, 0, $x, $y, $z, $h);
    }
}