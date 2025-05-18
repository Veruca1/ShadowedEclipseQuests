sub EVENT_ITEM_CLICK {
    if ($client) {
        # Set player level to 61
        $client->SetLevel(61);

        $client->Message(15, "Welcome to level 61!");

        # Remove the item from inventory after use
        $client->RemoveItem(40392);
    }
}