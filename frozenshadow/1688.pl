sub EVENT_SPAWN {
    # Send a signal with ID 10 and data 2
    quest::signalwith(10, 2);

    # Check if there are clients in the zone
    foreach my $client ($entity_list->GetClientList()) {
        if ($client) {
            # Send a green message to all clients
            $client->Message(14, "Thank you for rescuing me from this hell hole. I will meet up with you again when the time is right.");
        }
    }

    # Set a timer to depop after 2 minutes (120 seconds)
    quest::settimer("depop", 120);
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        # Stop the timer and depop the NPC
        quest::stoptimer("depop");
        quest::depop();
    }
}
