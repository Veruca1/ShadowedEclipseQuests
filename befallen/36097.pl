# 36097.pl
sub EVENT_DEATH_COMPLETE {
    # Coordinates where the new NPC will spawn
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();
    
    # Spawn the new NPC (36119)
    quest::spawn2(36119, 0, 0, $x, $y, $z, $h);
    
    # Set a global flag to indicate the NPC has spawned
    quest::setglobal("spawn_36119", 1, 3, "H6");
}