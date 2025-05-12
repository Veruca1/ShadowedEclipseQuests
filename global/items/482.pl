sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 482
    if ($itemid == 482) {
        # Depop all NPCs of type 1603
        quest::depopall(1603);
    }
}
