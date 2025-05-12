sub EVENT_DEATH_COMPLETE {
    # Define the zone ID for Wakening
    my $wakening_zone_id = 119;

    # Check if the current zone is Wakening
    if ($zoneid == $wakening_zone_id) {
        # Define the chance to spawn NPC
        my $chance_to_spawn = 13; # 13% chance

        # Generate a random number between 1 and 100
        my $random_chance = int(rand(100)) + 1;

        # Only proceed if the random number is less than or equal to the chance to spawn
        if ($random_chance <= $chance_to_spawn) {
            # Get the location of the dead NPC
            my $x = $npc->GetX();
            my $y = $npc->GetY();
            my $z = $npc->GetZ();
            my $h = $npc->GetHeading();

            # Spawn NPC 1745 at the death location
            quest::spawn2(1745, 0, 0, $x, $y, $z, $h);
        }
    }
}
