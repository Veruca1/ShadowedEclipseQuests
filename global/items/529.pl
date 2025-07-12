sub EVENT_ITEM_CLICK {
    my $item_id = $itemid;                 # The ID of the item being clicked (Philosopher's Stone)
    my $philosopher_stone_id = 529;        # ID for Philosopher's Stone
    my @allowed_item_ids = (530, 42472);   # Valid items to transmute

    if ($item_id == $philosopher_stone_id) {
        my $cursor_item = $client->GetItemAt(33); # Slot 33 = cursor

        if (defined $cursor_item) {
            my $cursor_item_id = $cursor_item->GetID();

            if (grep { $_ == $cursor_item_id } @allowed_item_ids) {
                my $weighted_roll = int(rand(100)) + 1;
                my $random_platinum;

                if ($cursor_item_id == 530) {
                    # Flat random for 530: 5,000–10,000
                    $random_platinum = int(rand(5001)) + 5000;
                } elsif ($cursor_item_id == 42472) {
                    # Weighted random for 42472 with 5k minimum
                    if ($weighted_roll <= 60) {
                        $random_platinum = int(rand(2001)) + 5000;   # 5,000–7,000
                    } elsif ($weighted_roll <= 90) {
                        $random_platinum = int(rand(5000)) + 7001;   # 7,001–12,000
                    } else {
                        $random_platinum = int(rand(8000)) + 12001;  # 12,001–20,000
                    }
                }

                quest::removeitem($cursor_item_id, 1);               # Remove used item
                $client->AddMoneyToPP(0, 0, 0, $random_platinum, 1); # Add platinum

                $client->Message(15, "✨ The ancient magic of the Philosopher's Stone shimmers! ✨ Your item has been transfigured into $random_platinum platinum pieces!");
            } else {
                $client->Message(13, "⚡ The Philosopher's Stone rejects the item! Only certain items can be transfigured.");
            }
        } else {
            $client->Message(13, "⚡ The Philosopher's Stone hums with power, but nothing happens. Perhaps you should place a valid item on your cursor to transfigure it?");
        }
    }
}