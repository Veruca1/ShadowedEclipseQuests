sub EVENT_ITEM_CLICK {
    my $char_id = $client->CharacterID();
    my $item_kills = "$char_id-32463";  # Using the item ID as part of the unique key
    my $kill_count = quest::get_data($item_kills);  # Retrieve the current kill count
    
    # The rest of the code will run without checking for 750 kills or upgrading the item
    $client->Message(14, "You currently have $kill_count kills.");
}