sub EVENT_ITEM_CLICK {
    # Grant zone access to Kael Drakkel (zone ID 113)
    quest::set_zone_flag(113);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to Kael Drakkel.");

    # Check if the item exists and remove it
    if (quest::countitem(664) >= 1) {
        quest::removeitem(664, 1);
    }
}
