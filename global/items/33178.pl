sub EVENT_ITEM {
    # Check if the player handed in the 'Companion's Armory' (Bag item ID 33178)
    if ($item1 == 33178) {
        my @bag_items = quest::getcontaineritems(33178);  # Get the items in the bag
        
        # Loop through items in the bag
        foreach my $slot (0..$#bag_items) {
            my $item = $bag_items[$slot];  # Get item in each slot
            
            # Equip the pet with items from the corresponding bag slot
            if ($slot == 0) {
                quest::equippet($item, 13);  # Slot 1 -> Main Hand (13)
            } elsif ($slot == 1) {
                quest::equippet($item, 14);  # Slot 2 -> Off Hand (14)
            } elsif ($slot == 2) {
                quest::equippet($item, 1);   # Slot 3 -> Head (1)
            } elsif ($slot == 3) {
                quest::equippet($item, 5);   # Slot 4 -> Chest (5)
            } elsif ($slot == 4) {
                quest::equippet($item, 7);   # Slot 5 -> Legs (7)
            } elsif ($slot == 5) {
                quest::equippet($item, 8);   # Slot 6 -> Feet (8)
            } elsif ($slot == 6) {
                quest::equippet($item, 10);  # Slot 7 -> Arms (10)
            } elsif ($slot == 7) {
                quest::equippet($item, 11);  # Slot 8 -> Hands (11)
            } elsif ($slot == 8) {
                quest::equippet($item, 9);   # Slot 9 -> Neck (9)
            } elsif ($slot == 9) {
                quest::equippet($item, 12);  # Slot 10 -> Back (12)
            }
        }
        
        # Notify the player that the pet has been equipped
        quest::say("Your pet has been equipped with items from the Companion's Armory.");
    }
}
