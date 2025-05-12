sub EVENT_ITEM_CLICK {
    # Check if the item clicked is item ID 402
    if ($itemid == 402) {
        # Assign task ID 28 to the player
        quest::assigntask(28);

        # Remove item 402 from the player's inventory
        quest::removeitem(402);

        # Grant access to specified zones
        quest::set_zone_flag(32);   # soldungb
        quest::set_zone_flag(73);   # permafrost
        quest::set_zone_flag(96);   # timorous
        quest::set_zone_flag(91);   # skyfire
    }
}
