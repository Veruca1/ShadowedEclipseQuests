sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 485
    if ($itemid == 485) {
        # Depop all NPCs of type 1607
        quest::depopall(1607);
    }
}
