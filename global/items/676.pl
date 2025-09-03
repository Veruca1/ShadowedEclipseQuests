sub EVENT_ITEM_CLICK {
    my $aa_id = 418;  # Planar Power Rank 8 AA ID
    my $max_rank = 8;

    if ($client) {
        my $current_rank = $client->GetAA($aa_id);

        if ($current_rank >= $max_rank) {
            $client->Message(13, "You already have Planar Power Rank $current_rank or higher.");
            $client->RemoveItem(676);  # Still remove the item
            return;
        }

        $client->IncrementAA($aa_id);  # Increment AA by 1
        $client->Message(15, "You have gained Planar Power Rank " . ($current_rank + 1) . "!");

        $client->RemoveItem(676);  # Remove the item after use
    }
}