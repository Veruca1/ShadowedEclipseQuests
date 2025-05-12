sub EVENT_DEATH_COMPLETE {
    # Define the zone ID for Crypt of Dalnir
    my $dalnir_zone_id = 104;

    # List of NPC IDs to be excluded from spawning new NPCs
    my @excluded_npc_ids = (104077, 1368, 1369);

    # Check if the current zone is Crypt of Dalnir
    if ($zoneid == $dalnir_zone_id) {
        # Get the ID of the dead NPC
        my $dead_npc_id = $npc->GetNPCTypeID();

        # Check if the dead NPC's ID is not in the excluded list
        if (!grep { $_ == $dead_npc_id } @excluded_npc_ids) {
            # Define the chance to spawn NPC 1370
            my $chance_to_spawn = 8; # 8% chance

            # Generate a random number between 1 and 100
            my $random_chance = int(rand(100)) + 1;

            # Only proceed if the random number is less than or equal to the chance to spawn
            if ($random_chance <= $chance_to_spawn) {
                # Get the location of the dead NPC
                my $x = $npc->GetX();
                my $y = $npc->GetY();
                my $z = $npc->GetZ();
                my $h = $npc->GetHeading();

                # Spawn NPC 1370 at the death location
                quest::spawn2(1370, 0, 0, $x, $y, $z, $h);
                quest::shout("The curse continues as another horror rises from the crypt!");
            }
        }
    }
}
sub EVENT_DEATH_COMPLETE {
    my $chance = int(rand(100));  # Generate a random number between 0 and 99
    if ($chance < 15) {  # 15% chance to spawn NPC 1370
        # Spawn NPC 1370 in the same location as the dead NPC
        quest::spawn2(1370, 0, 0, $x, $y, $z, $h);
        
    }
}
