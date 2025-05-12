sub EVENT_ITEM_CLICK {
    # Debug: Print the item ID clicked
    #$client->Message(315, "Item ID clicked: $itemid");

    # Check if the clicked item is 487
    if ($itemid == 487) {
        # Depop all NPCs of type 1609
        quest::depopall(1609);
    }
}
