sub EVENT_ITEM_CLICK {    
    quest::set_zone_flag(164);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to The Deep.");

    # Check if the item exists and remove it
    if (quest::countitem(40394) >= 1) {
        quest::removeitem(40394, 1);
    }
}