sub EVENT_ITEM_CLICK {
    if ($client) {
        my $level = $client->GetLevel();

        if ($level >= 60) {
            # Set player level to 61
            $client->SetLevel(61);
            $client->Message(15, "Welcome to level 61!");

            # Remove the item from inventory after use
            $client->RemoveItem(40392);
        } else {
            $client->Message(13, "You must be at least level 60 to use this item.");
        }
    }
}