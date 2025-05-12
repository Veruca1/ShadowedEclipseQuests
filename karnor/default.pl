sub EVENT_DEATH_COMPLETE {
    # Define the zone ID for Karnors Castle
    my $karnor_zone_id = 102;

    # List of NPC IDs to be excluded from spawning new NPCs
    my @excluded_npc_ids = (1425, 1439, 1442, 1443, 1445, 1438, 1440, 1441);

    # Check if the current zone is Karnors Castle
    if ($zoneid == $karnor_zone_id) {
        # Get the ID of the dead NPC
        my $dead_npc_id = $npc->GetNPCTypeID();

        # Check if the dead NPC's ID is not in the excluded list
        if (!grep { $_ == $dead_npc_id } @excluded_npc_ids) {
            # Define the chance to spawn NPC 1436
            my $chance_to_spawn = 6; # 6% chance

            # Generate a random number between 1 and 100
            my $random_chance = int(rand(100)) + 1;

            # Only proceed if the random number is less than or equal to the chance to spawn
            if ($random_chance <= $chance_to_spawn) {
                # Get the location of the dead NPC
                my $x = $npc->GetX();
                my $y = $npc->GetY();
                my $z = $npc->GetZ();
                my $h = $npc->GetHeading();

                # Spawn NPC 1436 at the death location
                quest::spawn2(1436, 0, 0, $x, $y, $z, $h);
                # Uncomment the line below if you want a shout message
                # quest::shout("The curse continues as another horror rises from the crypt!");
            }
        }
    }
}
