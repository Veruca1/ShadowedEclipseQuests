sub EVENT_ITEM_CLICK {
    my $aa_id = 418;  # Planar Power Rank 8 AA ID

    if ($client) {
        # Increment the AA (grants the AA and increases its rank by 1)
        $client->IncrementAA($aa_id);  # Increments the AA

        $client->Message(15, "You have gained Planar Power Rank 8!");
        
        # Remove the item from inventory after use
        $client->RemoveItem(676);
    }
}