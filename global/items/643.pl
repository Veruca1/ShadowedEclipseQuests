sub EVENT_ITEM_CLICK {
    # Grant zone access to Wakening Lands (zone ID 119)
    quest::set_zone_flag(119);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to Wakening Lands.");

    # Check if the item exists and remove it
    if (quest::countitem(643) >= 1) {
        quest::removeitem(643, 1);
    }
}