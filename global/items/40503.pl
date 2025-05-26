sub EVENT_ITEM_CLICK {
    my $char_id = $client->CharacterID();

    my @parcels = (
        {
            char_id   => $char_id,
            item_id   => 40503,  # Easy
            quantity  => 1,
            from_name => "Expedition Dispatcher",
            note      => "Use this to start the Easy Easter expedition.",
        },
        {
            char_id   => $char_id,
            item_id   => 40504,  # Medium
            quantity  => 1,
            from_name => "Expedition Dispatcher",
            note      => "Use this to start the Medium Easter expedition.",
        },
        {
            char_id   => $char_id,
            item_id   => 40505,  # Hard
            quantity  => 1,
            from_name => "Expedition Dispatcher",
            note      => "Use this to start the Hard Easter expedition.",
        },
    );

    foreach my $parcel (@parcels) {
        quest::send_parcel($parcel);
    }

    $client->Message(15, "You receive 3 Easter DZ Stones via parcel.");
}
