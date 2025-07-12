sub EVENT_DEATH_COMPLETE {
    my $npcid_to_spawn = 1505;

    # Check if the NPC to spawn is already alive in the zone
    my $existing_mob = $entity_list->GetMobByNpcTypeID($npcid_to_spawn);

    if (!$existing_mob) {
        # Spawn the NPC since it does not already exist
        quest::spawn2($npcid_to_spawn, 0, 0, $x, $y, $z, $h);
    }
}