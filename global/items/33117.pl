sub EVENT_ITEM_CLICK {
    # Define the item ID to summon
    my $summon_item_id = 33118;

    # Summon the item (adds the item to the player's inventory)
    $client->SummonItem($summon_item_id);

    # Optionally, you can send a message to the player to confirm the summon
    $client->Message(15, "You have summoned an item!");

    # To remove the original item (32481) from the player's inventory, use this line:
    # $client->TakeItemFromInventory($itemid);
}
