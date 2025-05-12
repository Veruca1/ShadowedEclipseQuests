sub EVENT_ITEM_CLICK {    
    quest::set_zone_flag(81);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to The Temple of Droga.");

    # Check if the item exists and remove it
    if (quest::countitem(32344) >= 1) {
        quest::removeitem(32344, 1);
    }
}
