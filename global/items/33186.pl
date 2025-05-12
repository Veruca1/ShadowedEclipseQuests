sub EVENT_ITEM_CLICK {    
    my $char_id = $client->CharacterID();                   # Get the player's character ID
    my $flag_poke4 = "$char_id-poke_pet_upgrade4";           # Unique flag per character for upgrade 4
    my $name = $client->GetCleanName();                      # Get player's name for broadcast

    if (quest::get_data($flag_poke4)) {
        $client->Message(15, "You have already upgraded your poke pet (fourth upgrade). The item has no effect.");
    } else {
        quest::set_zone_flag(44);                            # Najena zone ID

        # Broadcast a message to all players that the user has earned access
        quest::we(14, "$name has achieved their fourth poke pet upgrade!");
        plugin::scale_player_pet($client);

        quest::set_data($flag_poke4, 1);                     # Set the databucket flag for upgrade 4

        # Check if the item exists and remove it
        if (quest::countitem(33186) >= 1) {
            quest::removeitem(33186, 1);
        }
    }
}
