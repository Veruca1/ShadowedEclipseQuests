sub EVENT_ITEM_CLICK {
    # Define the item ID to summon
    my $summon_item_id = 40473;

    # Summon the item (adds the item to the player's inventory)
    $client->SummonItem($summon_item_id);

    # Optionally, you can send a message to the player to confirm the summon
    $client->Message(15, "You have summoned the Mirrored Bot Gear!");

}