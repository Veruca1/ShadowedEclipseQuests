sub EVENT_ITEM_CLICK {    
    quest::set_zone_flag(128);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to The Sleeper`s Tomb.");

    # Check if the item exists and remove it
    if (quest::countitem(825) >= 1) {
        quest::removeitem(825, 1);
    }
}