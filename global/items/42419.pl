sub EVENT_ITEM_CLICK {
    # Only allow use in The Deep (zone ID 164)
    if ($zoneid != 164) {
        $client->Message(13, "Nothing happens.");
        return;
    }

    # Grant Maiden's Eye zone flag (zone ID 173)
    quest::set_zone_flag(173);

    # Broadcast a message to all players
    quest::we(14, "$name has earned access to Maiden's Eye.");

    # Always remove one item
    quest::removeitem(42419, 1);
}