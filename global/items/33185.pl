sub EVENT_ITEM_CLICK {    
    my $char_id = $client->CharacterID();                   # Get the player's character ID
    my $flag_poke2 = "$char_id-poke_pet_upgrade2";           # Unique flag per character for upgrade 2
    my $name = $client->GetCleanName();                      # Get player's name for broadcast

    if (quest::get_data($flag_poke2)) {
        $client->Message(15, "You have already upgraded your poke pet (second upgrade). The item has no effect.");
    } else {
        quest::set_zone_flag(36);

        # Broadcast a message to all players that the user has earned access
        quest::we(14, "$name has upgraded their poke pet even further!");
        plugin::scale_player_pet($client);

        quest::set_data($flag_poke2, 1);                     # Set the databucket flag for upgrade 2

        # Check if the item exists and remove it
        if (quest::countitem(33185) >= 1) {
            quest::removeitem(33185, 1);
        }
    }
}
