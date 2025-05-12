sub EVENT_ITEM_CLICK { 
    my $aa_points_to_add = 1;  # Number of AA points to grant
    my $item_id = 489;         # The item ID of the consumable item

    # Add the AA points to the client
    $client->AddAAPoints($aa_points_to_add);

    # Remove the item by its ID
    $client->RemoveItem($item_id, 1); # Removes 1 item from the stack by ID
}
