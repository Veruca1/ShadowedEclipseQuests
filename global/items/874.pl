sub EVENT_ITEM_CLICK {    
    quest::set_zone_flag(17);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to Blackburrow.");

    # Check if the item exists and remove it
    if (quest::countitem(874) >= 1) {
        quest::removeitem(874, 1);
    }
}