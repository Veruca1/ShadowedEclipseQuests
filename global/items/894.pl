sub EVENT_ITEM_CLICK {            
    my $aa_id = 1550;  # Unflinching Resolve Rank 2 AA ID 
    my $flag_key = "flag_894_" . $client->CharacterID(); # Unique flag per character for Rank 2

    if ($client) {
        # Check if the player has already used the item
        if (quest::get_data($flag_key)) {
            $client->Message(13, "You have already learned Unflinching Resolve Rank 2.");
            return;
        }

        # Grant the AA
        $client->IncrementAA($aa_id);
        $client->Message(15, "You feel a surge of unflinching resolve!");

        # Set flag so they cannot gain it again
        quest::set_data($flag_key, 1);

        # Remove the item from inventory
        quest::removeitem(894, 1);
    }
}
