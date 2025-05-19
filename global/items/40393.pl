sub EVENT_ITEM_CLICK {    
    quest::set_zone_flag(153);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to The Echo Caverns.");

    # Check if the item exists and remove it
    if (quest::countitem(40393) >= 1) {
        quest::removeitem(40393, 1);
    }
}