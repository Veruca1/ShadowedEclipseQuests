sub EVENT_ITEM {
    # Get all clients in the zone
    my @clients = $entity_list->GetClientList();

    # Check if the player gives the hammer (item ID 591)
    if (plugin::takeItems(591 => 1)) {
        # Depop the current rock NPC (1703) and spawn NPC 1700 in its place
        quest::depop();
        quest::spawn2(1700, 0, 0, $x, $y, $z, $h);  # Spawn NPC 1700 at the current location

        # Level up the player to level 2
        $client->AddLevelBasedExp(100, 2);  # Level 2 XP
        $client->Message(14, "You have been leveled up to level 2!");

        # Send a green message to all clients in the zone
        foreach my $client (@clients) {
            if ($client) {
                $client->Message(14, "The rock is destroyed, and something else appears in its place.");
            }
        }

        return 1;  # Return 1 to indicate the item was used successfully
    }
    
    # Check if the player gives the shield (item ID 592)
    elsif (plugin::takeItems(592 => 1)) {
        # Depop the current rock NPC (1703)
        quest::depop();

        # Spawn NPC 1701 (statue) at the specified location
        quest::spawn2(1701, 0, 0, -230.30, 1426.83, 133.69, 486.25);  # Spawn NPC 1701 (statue)

        # Level up the player to level 2
        $client->AddLevelBasedExp(100, 2);  # Level 2 XP
        $client->Message(14, "You have been leveled up to level 2!");

        # Send a green message to all clients in the zone
        foreach my $client (@clients) {
            if ($client) {
                $client->Message(14, "The rock has been protected, and a statue appears beside the rock.");
            }
        }

        return 1;  # Return 1 to indicate the item was used successfully
    }
    
    # If the item given is neither the hammer nor the shield, return it to the player
    plugin::return_items(\%itemcount);
}
