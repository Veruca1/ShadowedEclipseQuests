sub EVENT_ITEM_CLICK {
    # Grant zone access to Cobalt Scar (zone ID 117)
    quest::set_zone_flag(117);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to Cobalt Scar.");

    # Check if the item exists and remove it
    if (quest::countitem(650) >= 1) {
        quest::removeitem(650, 1);
    }
}
