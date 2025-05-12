sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 483
    if ($itemid == 483) {
        # Depop all NPCs of type 1605
        quest::depopall(1605);
    }
}
