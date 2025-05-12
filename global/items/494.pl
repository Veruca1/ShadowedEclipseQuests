sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 494
    if ($itemid == 494) {
        # Depop all NPCs of type 1613
        quest::depopall(1613);
    }
}
