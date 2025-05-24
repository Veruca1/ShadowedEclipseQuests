sub EVENT_ITEM_CLICK {
    my $aa_id = 1229;  # Secondary Recall AA ID

    if ($client) {
        # Increment the AA (grants the AA and increases its rank by 1)
        $client->IncrementAA($aa_id);  # Increments the AA

        $client->Message(15, "You have gained Secondary Recall!");
        
        # Remove the item from inventory after use
        $client->RemoveItem(40468);
    }
}