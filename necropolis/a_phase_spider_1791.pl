sub EVENT_DEATH_COMPLETE {
    my $chance = int(rand(100)) + 1;
    if ($chance <= 30) {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();
        quest::spawn2(1792, 0, 0, $x, $y, $z, $h);
    }
}