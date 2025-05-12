sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 484
    if ($itemid == 484) {
        # Depop all NPCs of type 1606
        quest::depopall(1606);
    }
}
