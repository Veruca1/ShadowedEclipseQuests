sub EVENT_ITEM_CLICK {    
    quest::set_zone_flag(124);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to The Temple of Veeshan.");

    # Check if the item exists and remove it
    if (quest::countitem(870) >= 1) {
        quest::removeitem(870, 1);
    }
}