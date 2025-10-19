sub EVENT_ITEM_CLICK {
    my $item_id = $itemid;                 # The ID of the item being clicked (Philosopher's Stone)
    my $philosopher_stone_id = 529;        # ID for Philosopher's Stone
    my @allowed_item_ids = (530, 42472);   # Valid items to transmute

    if ($item_id == $philosopher_stone_id) {
        my $cursor_item = $client->GetItemAt(33); # Slot 33 = cursor

        if (defined $cursor_item) {
            my $cursor_item_id = $cursor_item->GetID();

            if (grep { $_ == $cursor_item_id } @allowed_item_ids) {
                my $stack_count = $cursor_item->GetCharges();
                my $total_platinum = 0;

                for (1 .. $stack_count) {
                    if ($cursor_item_id == 530) {
                        $total_platinum += int(rand(5001)) + 5000;
                    } elsif ($cursor_item_id == 42472) {
                        my $weighted_roll = int(rand(100)) + 1;
                        if ($weighted_roll <= 60) {
                            $total_platinum += int(rand(5001)) + 85000;
                        } elsif ($weighted_roll <= 90) {
                            $total_platinum += int(rand(7001)) + 90000;
                        } else {
                            $total_platinum += int(rand(8001)) + 97000;
                        }
                    }
                }

                quest::removeitem($cursor_item_id, $stack_count);               # Remove full stack
                $client->AddMoneyToPP(0, 0, 0, $total_platinum, 1);             # Add total platinum

                $client->Message(15, "✨ The Philosopher's Stone glows brightly! Your stack of $stack_count item(s) has been transfigured into $total_platinum platinum pieces!");
            } else {
                $client->Message(13, "⚡ The Philosopher's Stone rejects the item! Only certain items can be transfigured.");
            }
        } else {
            $client->Message(13, "⚡ The Philosopher's Stone hums with power, but nothing happens. Place a valid item on your cursor to transfigure it.");
        }
    }
}