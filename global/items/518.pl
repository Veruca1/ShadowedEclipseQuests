sub EVENT_ITEM_CLICK {
    # Set zone flag for Eastern Wastes (zone ID 116)
    quest::set_zone_flag(116); 

    # Send a yellow message announcing the access
    quest::we(14, "$name has earned access to Eastern Wastes!");

    # Consume the item so the player no longer has it
    quest::take_items(518 => 1);
}
