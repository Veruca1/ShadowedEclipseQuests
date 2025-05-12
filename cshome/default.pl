sub EVENT_ZONE {
    # Check if NPC ID 10 (zone_controller) exists in the zone
    my $existing_npc = $entity_list->GetNPCByID(10);
    
    # If the zone_controller isn't in the zone, spawn it at the given location
    if (!$existing_npc) {
        my $x = 129.98;  # X coordinate
        my $y = 545.96;  # Y coordinate
        my $z = 44.81;   # Z coordinate
        my $h = 0;       # Heading (rotation), you can adjust if needed
        
        # Spawn the NPC at the specified coordinates
        quest::spawn2(10, 0, 0, $x, $y, $z, $h);
        quest::shout("The Zone Controller has appeared in the zone!");
    }
}