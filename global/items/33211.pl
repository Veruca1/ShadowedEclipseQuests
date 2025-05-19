sub EVENT_ITEM_CLICK {    
    quest::set_zone_flag(156);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to The Paludal Caverns.");

    # Check if the item exists and remove it
    if (quest::countitem(33211) >= 1) {
        quest::removeitem(33211, 1);
    }
}