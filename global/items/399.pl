sub EVENT_ITEM_CLICK {
    my $char_id = $client->CharacterID();
    my $item_kills = "$char_id-399";  # Using the item ID as part of the unique key
    my $kill_count = quest::get_data($item_kills);  # Retrieve the current kill count
    
    # Output the current kill count without any nuking or summoning
    $client->Message(14, "You currently have $kill_count kills.");
}