sub EVENT_ITEM_CLICK {
    if ($client) {
        my $level = $client->GetLevel();

        if ($level >= 60) {
            # Use GM command to level the player to 61
            $client->SetLevel(61, 1);  # or true


            # Optional: Message and cleanup
            $client->Message(15, "Welcome to level 61!");
            $client->RemoveItem(40392);  # Remove the item after use
        } else {
            $client->Message(13, "You must be at least level 60 to use this item.");
        }
    }
}
