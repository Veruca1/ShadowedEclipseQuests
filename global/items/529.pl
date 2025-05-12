sub EVENT_ITEM_CLICK {
    my $item_id = $itemid;                # The ID of the item being clicked (Philosopher's Stone)
    my $philosopher_stone_id = 529;      # ID for Philosopher's Stone
    my @allowed_item_ids = (530);        # Replace these with the allowed item IDs for transmutation

    # Check if the clicked item is the Philosopher's Stone
    if ($item_id == $philosopher_stone_id) {
        # Check if there's an item on the cursor (slot 33)
        my $cursor_item = $client->GetItemAt(33); # Cursor slot is 33

        if (defined $cursor_item) {
            my $cursor_item_id = $cursor_item->GetID();

            # Verify if the item on the cursor is allowed for transmutation
            if (grep { $_ == $cursor_item_id } @allowed_item_ids) {
                # Weighted random platinum generation
                my $weighted_roll = int(rand(100)) + 1;
                my $random_platinum;

                if ($weighted_roll <= 60) {
                    # 1-300 platinum (common)
                    $random_platinum = int(rand(300)) + 1;
                } elsif ($weighted_roll <= 90) {
                    # 301-700 platinum (medium)
                    $random_platinum = int(rand(400)) + 301;
                } else {
                    # 701-1000 platinum (rare)
                    $random_platinum = int(rand(300)) + 701;
                }

                # Delete the item on the cursor
                quest::removeitem($cursor_item_id, 1);  # Remove 1 of the item from cursor

                # Add the platinum to the player's inventory
                $client->AddMoneyToPP(0, 0, 0, $random_platinum, 1); # Auto-loot enabled

                # Send feedback to the player
                $client->Message(15, "✨ The ancient magic of the Philosopher's Stone shimmers! ✨ Your item has been transfigured into $random_platinum platinum pieces!");
            } else {
                # Item is not allowed for transmutation
                $client->Message(13, "⚡ The Philosopher's Stone rejects the item! Only certain items can be transfigured.");
            }
        } else {
            # No item on the cursor
            $client->Message(13, "⚡ The Philosopher's Stone hums with power, but nothing happens. Perhaps you should place a valid item on your cursor to transfigure it?");
        }
    }
}
