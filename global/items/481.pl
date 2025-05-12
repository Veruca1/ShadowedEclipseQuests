sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 481
    if ($itemid == 481) {
        # Depop all NPCs of type 1602
        quest::depopall(1602);
    }
}
