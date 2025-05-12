sub EVENT_ITEM_CLICK {
    # Check if the player has the key (item ID 715)
    if (quest::countitem(715) >= 1) {
        # Grant zone access to Runnyeye (zone ID 11)
        quest::set_zone_flag(11); 

        # Broadcast a message to all players that the user has earned access
        quest::we(14, "$name has earned access to Runnyeye.");

        # Remove the key item from the player's inventory
        quest::removeitem(715, 1); 
    }
}