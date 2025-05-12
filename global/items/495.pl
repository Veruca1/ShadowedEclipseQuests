sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 495
    if ($itemid == 495) {
        # Depop all NPCs of type 1614
        quest::depopall(1614);
    }
}
