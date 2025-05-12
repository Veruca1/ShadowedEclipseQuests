sub EVENT_ITEM_CLICK {    
    quest::set_zone_flag(127);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to The Plane of Growth.");

    # Check if the item exists and remove it
    if (quest::countitem(871) >= 1) {
        quest::removeitem(871, 1);
    }
}