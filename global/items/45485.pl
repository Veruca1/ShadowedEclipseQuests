sub EVENT_ITEM_CLICK {
    # Only functions in The Fungus Grove (zone ID 157)
    if ($zoneid != 157) {
        $client->Message(13, "This key remains dormant outside the depths of the Fungus Grove.");
        return;
    }

    # Grant access to Grimling Forest (zone ID 167)
    quest::set_zone_flag(167);
    quest::we(14, "$name has attuned to the shadows of Grimling Forest.");
    $client->Message(15, "The key trembles softly... and crumbles in your grasp.");

    # Remove one copy of the key item (45485)
    quest::removeitem(45485, 1);
}