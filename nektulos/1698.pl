sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Define the first location and move NPC to it
        quest::moveto(-661.79, 1568.13, 22.68, 216.50, 1);
    }
}

sub EVENT_WAYPOINT_ARRIVE {
    # Get all clients in the zone
    my @clients = $entity_list->GetClientList();  # Get all clients in the zone

    foreach my $client (@clients) {
        # Check if client exists (may not be always defined)
        if ($client) {
            # Send a green message to the client (Message ID 14 is green)
            $client->Message(14, "Points to the top of the hill.");
        }
    }

    # Once at the first location, spawn the two NPCs (a rock and decaying skeleton)
    quest::spawn2(1703, 0, 0, -270.51, 1437.96, 138.53, 480.00); # A rock
    quest::spawn2(1702, 0, 0, -274.88, 1467.38, 140.70, 462.00); # Decaying skeleton

    # Set the depop timer for this NPC
    quest::settimer("depop", 5);
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        # Signal NPC 10 and depop this NPC
        quest::signalwith(10, 1);
        quest::depop();
    }
}
