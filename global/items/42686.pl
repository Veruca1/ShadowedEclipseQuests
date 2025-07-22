sub EVENT_ITEM_CLICK {
    # Ensure this item can only be clicked in The Twilight Sea (zone ID 170)
    if ($zoneid != 170) {
        $client->Message(13, "You sense this artifact will only function within the waves of The Twilight Sea.");
        return;
    }

    # Always succeed: flag for Fungus Grove (zone ID 157)
    quest::set_zone_flag(157);
    quest::we(14, "$name has earned access to The Fungus Grove!");
    $client->Message(15, "The artifact pulses with fungal spores before crumbling to dust.");

    # Always remove one item (42686)
    quest::removeitem(42686, 1);
}