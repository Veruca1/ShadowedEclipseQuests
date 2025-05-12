sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 492
    if ($itemid == 492) {
        # Depop all NPCs of type 1611
        quest::depopall(1611);
    }
}
