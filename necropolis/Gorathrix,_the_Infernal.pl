sub EVENT_SPAWN {   
    $npc->CameraEffect(1000, 3);    

    # Get all clients in the zone
    my @clients = $entity_list->GetClientList();

    # Define the text for the marquee
    my $text = "You feel a disturbance and an immense heat from the north.";

    # Send the marquee message to each client in the zone
    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);  # Broadcasting to all players
    }
}
