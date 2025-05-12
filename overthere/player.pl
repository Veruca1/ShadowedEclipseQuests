sub EVENT_CLICKDOOR {
    my $required_level = 50;  # Set the required level for access
    my $doorid = 19;  # Change this if the door ID is different

    # Check if the clicked door is the one in Overthere (door ID 19)
    if ($doorid == 19) {
        # Check if player meets the required level or has the zone flag
        if ($client->GetLevel() >= $required_level || quest::has_zone_flag(93)) {
            # If player doesn't have the zone flag yet, grant it
            if (quest::has_zone_flag(93) != 1) {
                quest::set_zone_flag(93);  # Set zone flag for the Overthere
            }
        }
        else {
            # Deny access if the conditions are not met
            $client->Message(15, "You are not yet ready to pass through this door.");
        }
    }
}