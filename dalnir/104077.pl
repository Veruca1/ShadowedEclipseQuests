sub EVENT_AGGRO {
    # Aggro shout when The Kly engages in combat
    quest::shout("Fools! Your bodies will fuel my experiments, and your souls shall never escape the crypt!");
}

sub EVENT_DEATH_COMPLETE {
    # Coordinates where NPC 1368 will spawn (adjust as needed)
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();
    
    # Spawn NPC 1368 at the location of NPC 104007's death
    quest::spawn2(1368, 0, 0, $x, $y, $z, $h);
}
