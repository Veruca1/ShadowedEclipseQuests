sub EVENT_ITEM_CLICK {    
    my $char_id = $client->CharacterID();                   # Get the player's character ID
    my $flag_poke5 = "$char_id-poke_pet_upgrade5";           # Unique flag per character for upgrade 5
    my $name = $client->GetCleanName();                      # Get player's name for broadcast

    if (quest::get_data($flag_poke5)) {
        $client->Message(15, "You have already upgraded your poke pet (fifth upgrade). The item has no effect.");
    } else {
        quest::set_zone_flag(186);                           # Set flag for zone ID 186

        # Broadcast a message to all players that the user has earned access
        quest::we(14, "$name has massively upgraded their poke pet!");
        plugin::scale_player_pet($client);

        quest::set_data($flag_poke5, 1);                     # Set the databucket flag for upgrade 5

        # Check if the item exists and remove it
        if (quest::countitem(975) >= 1) {
            quest::removeitem(975, 1);
        }
    }
}
