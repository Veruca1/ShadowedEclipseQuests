sub EVENT_ITEM_CLICK {
    my $aa_id = 9600;  # Felix Fortuna of the Arcane AA ID

    if ($client) {
        # Increment the AA (grants the AA and increases its rank by 1)
        $client->IncrementAA($aa_id);  # Increments the AA

        $client->Message(15, "You have gained Felix Fortuna of the Arcane!");
        
        # Remove the item from inventory after use
        $client->RemoveItem(687);
    }
}