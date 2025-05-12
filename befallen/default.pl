sub EVENT_DEATH_COMPLETE {
    # Define the zone ID for Befallen
    my $befallen_zone_id = 36;

    # List of NPC IDs to be excluded from spawning new NPCs
    my @excluded_npc_ids = (36111, 36112, 36109, 36113);

    # Check if the current zone is Befallen
    if ($zoneid == $befallen_zone_id) {
        # Get the ID of the dead NPC
        my $dead_npc_id = $npc->GetNPCTypeID();

        # Check if the dead NPC's ID is in the excluded list
        if (!grep { $_ == $dead_npc_id } @excluded_npc_ids) {
            # Define the chance to spawn NPCs
            my $chance_to_spawn = 15; # 15% chance

            # Generate a random number between 1 and 100
            my $random_chance = int(rand(100)) + 1;

            # Only proceed if the random number is less than or equal to the chance to spawn
            if ($random_chance <= $chance_to_spawn) {
                # List of NPC IDs to choose from
                my @npc_ids = (36111, 36112, 36109, 36113);

                # Hash to keep track of which NPCs have been spawned
                my %spawned_npcs;

                # Loop until two unique NPCs have been selected
                while (keys %spawned_npcs < 2) {
                    my $random_npc = $npc_ids[int(rand(@npc_ids))];
                    $spawned_npcs{$random_npc} = 1;
                }

                # Get the location of the dead NPC
                my $x = $npc->GetX();
                my $y = $npc->GetY();
                my $z = $npc->GetZ();
                my $h = $npc->GetHeading();

                # Spawn the selected NPCs at the death location
                foreach my $npc_id (keys %spawned_npcs) {
                    quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
                }
            }
        }
    }
}