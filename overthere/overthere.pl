sub EVENT_CLICKDOOR {
    my $door_id = 19;  # ID of the Howling Stones door
    my $zone_flag = 105;  # The flag for Howling Stones access

    # Check if the clicked door is the Howling Stones door
    if ($doorid == $door_id) {
        # Check if the player has the flag for Howling Stones
        if ($client->HasZoneFlag($zone_flag)) {
            # If the player has the flag, teleport them to Charasis (Howling Stones)
            $client->MovePC(105, 0.00, 0.00, -3.93, 0.00);  # Charasis zone ID 105 with specific coordinates and heading
        } else {
            # If the player does not have the flag, deny access and send a message
            $client->Message(13, "You lack the necessary knowledge to enter the Howling Stones.");
        }
    }
}
