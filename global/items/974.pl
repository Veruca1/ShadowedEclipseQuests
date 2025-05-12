sub EVENT_ITEM_CLICK {    
    my $char_id = $client->CharacterID();                   # Get the player's character ID
    my $flag_poke3 = "$char_id-poke_pet_upgrade3";           # Unique flag per character for upgrade 3
    my $name = $client->GetCleanName();                      # Get player's name for broadcast

    if (quest::get_data($flag_poke3)) {
        $client->Message(15, "You have already upgraded your poke pet (third upgrade). The item has no effect.");
    } else {
        quest::set_zone_flag(63);                            # Estate of Unrest zone ID

        # Broadcast a message to all players that the user has earned access
        quest::we(14, "$name has upgraded their poke pet further!");
        plugin::scale_player_pet($client);

        quest::set_data($flag_poke3, 1);                     # Set the databucket flag for upgrade 3

        # Check if the item exists and remove it
        if (quest::countitem(974) >= 1) {
            quest::removeitem(974, 1);
        }
    }
}
