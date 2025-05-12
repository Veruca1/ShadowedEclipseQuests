sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 488
    if ($itemid == 488) {
        # Depop all NPCs of type 1610
        quest::depopall(1610);
    }
}
