sub EVENT_ITEM_CLICK {
    my $aa_id = 122;  # Combat Stability AA ID (Combat Stability Rank 5)

    if ($client) {
        # Increment the AA (grants the AA and increases its rank by 1)
        $client->IncrementAA($aa_id);  # Increments the AA

        $client->Message(13, "You have gained Combat Stability Rank 5!");  # Message for the player

        # Remove the item from inventory after use
        $client->RemoveItem(693);
    }
}