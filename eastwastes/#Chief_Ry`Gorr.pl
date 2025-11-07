sub EVENT_DEATH {
    quest::shout("I shall be avenged!!!!");

    # New fixed spawn location
    my $spawn_x = 440.86;
    my $spawn_y = -2948.24;
    my $spawn_z = 178.09;
    my $spawn_h = 291.75;  # Heading for all spawns

    # Set a flag to ensure only one 1653 NPC spawns
    my $rare_spawned = 0;

    # Spawn 6 NPCs
    for my $i (0 .. 5) {
        my $npc_id;

        # 15% chance to spawn the rare NPC (1653), but only once
        if (!$rare_spawned && rand(100) < 15) {
            $npc_id = 1653;
            $rare_spawned = 1;  # Set the flag so no more 1653 NPCs spawn
        } else {
            $npc_id = 116557;  # Spawn regular 116557 NPC
        }

        # Spawn the NPC at the fixed location with the given heading
        quest::spawn2($npc_id, 0, 0, $spawn_x, $spawn_y, $spawn_z, $spawn_h);
    }
}
