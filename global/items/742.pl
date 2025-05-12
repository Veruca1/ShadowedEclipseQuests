sub EVENT_ITEM_CLICK {
    # Grant zone access to Wakening Lands (zone ID 120)
    quest::set_zone_flag(120);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to The Western Wastes.");

    # Check if the item exists and remove it
    if (quest::countitem(742) >= 1) {
        quest::removeitem(742, 1);
    }
}