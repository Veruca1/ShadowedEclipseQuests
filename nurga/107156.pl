sub EVENT_DEATH_COMPLETE {
    # Get the location of the NPC at death
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();

    # Spawn NPC 107000 and 107003 at the specified locations
    quest::spawn2(107113, 0, 0, -907.67, -1589.01, -222.65, 460.25);  # Spawn 107113
    quest::spawn2(107114, 0, 0, -897.09, -1543.35, -222.65, 358.75);  # Spawn 107114
    quest::spawn2(107115, 0, 0, -972.17, -1516.91, -222.65, 182.25);  # Spawn 107115
    quest::spawn2(107116, 0, 0, -1005.39, -1560.05, -222.65, 123.50);  # Spawn 107116
}
