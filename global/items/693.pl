sub EVENT_ITEM_CLICK {
    my $aa_id = 122;  # Combat Stability AA ID
    my $max_rank = 5;

    if ($client) {
        my $current_rank = $client->GetAA($aa_id);

        if ($current_rank < $max_rank) {
            $client->IncrementAA($aa_id);  # Increment AA by 1
            $client->Message(13, "You have gained Combat Stability Rank " . ($current_rank + 1) . "!");
        } else {
            $client->Message(13, "You already have Combat Stability Rank $current_rank or higher.");
        }

        $client->RemoveItem(693);  # Always remove the item after use
    }
}