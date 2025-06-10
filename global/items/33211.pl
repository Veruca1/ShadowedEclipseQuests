sub EVENT_ITEM_CLICK {
    # Only allow use in Shadeweaver's Thicket (zone ID 165)
    if ($zoneid != 165) {
        $client->Message(13, "Nothing happens.");
        return;
    }

    # Grant Paludal Caverns zone flag (zone ID 156)
    quest::set_zone_flag(156);

    # Broadcast a message to all players
    quest::we(14, "$name has earned access to The Paludal Caverns.");

    # Remove the item if it exists
    if (quest::countitem(33211) >= 1) {
        quest::removeitem(33211, 1);
    }
}