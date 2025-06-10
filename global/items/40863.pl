sub EVENT_ITEM_CLICK {
    # Ensure this item can only be clicked in Maiden's Eye (zone ID 173)
    if ($zoneid != 173) {
        $client->Message(13, "You sense this item will only function in Maiden's Eye.");
        return;
    }

    # Roll for success (10% chance)
    my $roll = int(rand(100)) + 1;

    if ($roll <= 25) {
        # Success: Set the zone flag for Akheva Ruins (zone ID 179)
        quest::set_zone_flag(179);
        quest::we(14, "$name has earned access to Akheva Ruins!");
        $client->Message(15, "The artifact glows briefly before crumbling to dust.");
    } else {
        # Failure: Item crumbles with no effect
        $client->Message(13, "The artifact pulses... then crumbles into useless dust.");
    }

    # Remove the item in both cases
    if (quest::countitem(870) >= 1) {
        quest::removeitem(870, 1);
    }
}