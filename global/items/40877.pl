sub EVENT_ITEM_CLICK {
    # Ensure this item can only be clicked in Akheva Ruins (zone ID 179)
    if ($zoneid != 179) {
        $client->Message(13, "You sense this artifact will only function within the shadows of Akheva Ruins.");
        return;
    }

    # Always succeed
    quest::set_zone_flag(172);
    quest::we(14, "$name has earned access to Tenebrous Mountains!");
    $client->Message(15, "The artifact glows with umbral energy before crumbling to dust.");

    # Always remove one item (40877)
    quest::removeitem(40877, 1);
}