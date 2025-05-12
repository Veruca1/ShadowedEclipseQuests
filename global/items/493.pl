sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 493
    if ($itemid == 493) {
        # Depop all NPCs of type 1612
        quest::depopall(1612);
    }
}
