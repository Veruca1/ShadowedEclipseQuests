# NPC 107108 Script

sub EVENT_SPAWN {
    # Get the location of the NPC
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();

    # Spawn NPC 1352 at the same location
    my $existing = $entity_list->GetNPCByNPCTypeID(1352);
    $existing->Depop(1) if $existing;

    quest::spawn2(1352, 0, 0, $x, $y, $z, $h);
}

sub EVENT_DEATH_COMPLETE {
    # Get the location of the NPC at death
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();

    # Spawn NPC 107109 and 107110 at the same location
    quest::spawn2(107109, 0, 0, -907.67, -1589.01, -222.65, 460.25);  # Spawn 107109
    quest::spawn2(107110, 0, 0, -897.09, -1543.35, -222.65, 358.75);  # Spawn 107110
    quest::spawn2(107111, 0, 0, -972.17, -1516.91, -222.65, 182.25);  # Spawn 107110
    quest::spawn2(107112, 0, 0, -1005.39, -1560.05, -222.65, 123.50);  # Spawn 107110
    
}
