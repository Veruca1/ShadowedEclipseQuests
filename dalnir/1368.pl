sub EVENT_SPAWN {
    # Spawn shout when Dag the Blasphemer appears
    quest::shout("Tremble, mortals! You stand before Dag!, master of death and defiler of souls! Creator of Kurn's dagger of torture!");
}

sub EVENT_DEATH_COMPLETE {
    # Coordinates where NPC 1369 will spawn (adjust as needed)
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();
    
    # Spawn NPC 1369 at Dag's death location
    quest::spawn2(1369, 0, 0, $x, $y, $z, $h);
        
}
