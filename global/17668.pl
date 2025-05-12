sub EVENT_ITEM {
    # Check if the player has handed in the correct container
    if (plugin::check_handin(\%itemcount, 17668 => 1)) { # 17668 is the container ID
        # Check if the container has all required items
        my @required_items = (17669, 17670, 17671, 17672, 17673); # IDs of the items that need to be inside

        my $has_all_items = 1;
        foreach my $item_id (@required_items) {
            if (!plugin::check_hasitem(17668, $item_id)) { # Check if the item is in the container
                $has_all_items = 0;
                last;
            }
        }

        if ($has_all_items) {
            # Provide the final item directly to the player if all required items are in the container
            plugin::give_item(17674); # Final item ID
        } else {
            # Return items if not combined correctly
            plugin::return_items(\%itemcount);
        }
    } else {
        # Return items if the container ID is incorrect
        plugin::return_items(\%itemcount);
    }
}
