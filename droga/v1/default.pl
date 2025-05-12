sub EVENT_SPAWN_ZONE {
    # Location for NPC 1343 to spawn
    my $x = 1939.41;
    my $y = 518.86;
    my $z = -270.65;
    my $h = 0;

    # Check if NPC 1343 is already up, to avoid duplicates
    my $npc_check = $entity_list->GetNPCByNPCTypeID(1343);
    if (!$npc_check) {
        # Spawn NPC 1343 if it isn't already up
        quest::spawn2(1343, 0, 0, $x, $y, $z, $h);
    }
}
