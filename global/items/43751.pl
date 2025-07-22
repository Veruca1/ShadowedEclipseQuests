sub EVENT_ITEM_CLICK {
    # Ensure this item can only be clicked in Katta Castellum (zone ID 160)
    if ($zoneid != 160) {
        $client->Message(13, "You sense this artifact will only function within the walls of Katta Castellum.");
        return;
    }

    # Always succeed: flag for Twilight Sea (zone ID 170)
    quest::set_zone_flag(170);
    quest::we(14, "$name has earned access to The Twilight Sea!");
    $client->Message(15, "The artifact shimmers with dusky light before crumbling to dust.");

    # Always remove one item (43751)
    quest::removeitem(43751, 1);
}