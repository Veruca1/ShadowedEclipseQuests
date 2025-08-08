sub EVENT_ITEM_CLICK {
    if ($client) {
        my $level = $client->GetLevel();

        if ($level >= 61) {
            # Use GM command to level the player to 62
            $client->SetLevel(62, 1);  # or true


            # Optional: Message and cleanup
            $client->Message(15, "Welcome to level 62!");
            $client->RemoveItem(50265);  # Remove the item after use
        } else {
            $client->Message(13, "You must be at least level 61 to use this item.");
        }
    }
}