sub EVENT_DEATH_COMPLETE {
    # Define the zone ID for Crystal Caverns
    my $crystal_zone_id = 121;

    # List of NPC IDs that can trigger the spawn
    my @trigger_npc_ids = (121072, 121070, 121085, 1657);

    # Get the ID of the dead NPC
    my $dead_npc_id = $npc->GetNPCTypeID();

    # Check if the current zone is Crystal Caverns and the dead NPC is in the trigger list
    if ($zoneid == $crystal_zone_id && grep { $_ == $dead_npc_id } @trigger_npc_ids) {
        # Define the chance to spawn the new NPC
        my $chance_to_spawn = 20; # 20% chance

        # Generate a random number between 1 and 100
        my $random_chance = int(rand(100)) + 1;

        # Only proceed if the random number is less than or equal to the chance to spawn
        if ($random_chance <= $chance_to_spawn) {
            # Get the location of the dead NPC
            my $x = $npc->GetX();
            my $y = $npc->GetY();
            my $z = $npc->GetZ();
            my $h = $npc->GetHeading();

            # Spawn NPC ID 1656 at the death location
            quest::spawn2(1656, 0, 0, $x, $y, $z, $h);
        }
    }
}
