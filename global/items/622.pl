sub EVENT_ITEM_CLICK {
    # Grant zone access to Siren's Grotto (zone ID 125)
    quest::set_zone_flag(125);

    # Broadcast a message to all players that the user has earned access
    quest::we(14, "$name has earned access to Siren`s Grotto.");

    # Check if the item exists and remove it
    if (quest::countitem(622) >= 1) {
        quest::removeitem(622, 1);
    }
}
