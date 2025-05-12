sub EVENT_ENTERZONE {
    if ($zoneid == 127) {  # Plane of Growth zone ID
        my $instance_id = $client->GetInstanceID();
        my $start_x = 622.43;
        my $start_y = 98.13;
        my $start_z = -101.44;

        # Move player to starting position in the instance
        $client->MovePCInstance(127, $instance_id, $start_x, $start_y, $start_z, 0);

        # Start the timer to check the player's position every 5 seconds
        quest::settimer("growth_check", 5);
    }
}

sub EVENT_TIMER {
    if ($timer eq "growth_check") {
        my $start_x = 622.43;
        my $start_y = 98.13;
        my $start_z = -101.44;
        my $tolerance = 50;  # Allow some movement
        my $max_distance = 400 + $tolerance;  # Max allowable distance

        # Fetch client by ID since $client is not available in timers
        my $pc = $entity_list->GetClientByID($userid);
        return unless $pc;  # Exit if no player found (prevents crashes)

        # Get current player coordinates
        my $current_x = $pc->GetX();
        my $current_y = $pc->GetY();
        my $current_z = $pc->GetZ();

        # Calculate distance from the starting position
        my $distance = sqrt(($current_x - $start_x)**2 + ($current_y - $start_y)**2 + ($current_z - $start_z)**2);

        # If outside the allowed area, teleport them back
        if ($distance > $max_distance) {
            my $instance_id = $pc->GetInstanceID();
            $pc->MovePCInstance(127, $instance_id, $start_x, $start_y, $start_z, 0);
            $pc->Message(15, "The forces of twisted nature keep you confined to a 400-foot radius!");
        }
    }
}
