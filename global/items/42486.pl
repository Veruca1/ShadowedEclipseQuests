sub EVENT_ITEM_CLICK {
    # Ensure this item can only be clicked in Tenebrous Mountains (zone ID 172)
    if ($zoneid != 172) {
        $client->Message(13, "You sense this artifact will only function within the mists of Tenebrous Mountains.");
        return;
    }

    # Always succeed
    quest::set_zone_flag(160);
    quest::we(14, "$name has earned access to Katta Castellum!");
    $client->Message(15, "The artifact hums with a pale light before crumbling to dust.");

    # Always remove one item (42486)
    quest::removeitem(42486, 1);
}