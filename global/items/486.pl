sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 486
    if ($itemid == 486) {
        # Depop all NPCs of type 1608
        quest::depopall(1608);
    }
}
