sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Send message to client before moving
        my @clients = $entity_list->GetClientList();  # Get all clients in the zone

        foreach my $client (@clients) {
            # Check if client exists (may not be always defined)
            if ($client) {
                # Send a green message to the client (Message ID 14 is green)
                $client->Message(14, "The wolf gestures for you to follow.");
            }
        }

        # Move NPC to the new location
        quest::moveto(307.24, 940.79, 32.15, 144.25, 1);
    }
}

sub EVENT_WAYPOINT_ARRIVE {
    # Get all clients in the zone
    my @clients = $entity_list->GetClientList();  # Get all clients in the zone

    foreach my $client (@clients) {
        # Check if client exists (may not be always defined)
        if ($client) {
            # Send a green message to the client (Message ID 14 is green)
            $client->Message(14, "The wolf points for you to go ahead.");
        }
    }

    # Spawn NPC 1708 at the specified location
    quest::spawn2(1708, 0, 0, 509.26, 913.66, 6.41, 146.50);
    quest::depop();
}
