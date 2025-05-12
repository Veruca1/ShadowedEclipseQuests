sub EVENT_DEATH_COMPLETE {
    # Check if the Temporal Amplifier (NPC ID 1294) is up in the zone
    my $temporal_amplifier = $entity_list->GetMobByNpcTypeID(1294);

    if ($temporal_amplifier) {
        # Get the location of the dying NPC
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Spawn two NPCs with ID 1295 at the same location
        quest::spawn2(1295, 0, 0, $x, $y, $z, $h);
        quest::spawn2(1295, 0, 0, $x, $y, $z, $h);
    }
}
