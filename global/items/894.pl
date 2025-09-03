sub EVENT_ITEM_CLICK {            
    my $aa_id = 1550;  # Unflinching Resolve Rank 2 AA ID 
    my $flag_key = "flag_894_" . $client->CharacterID(); # Unique flag per character for Rank 2
    my $max_rank = 2;

    if ($client) {
        my $current_rank = $client->GetAA($aa_id);

        if ($current_rank >= $max_rank) {
            $client->Message(13, "You already have Unflinching Resolve Rank $current_rank or higher.");
            quest::removeitem(894, 1);  # Still remove the item
            return;
        }

        if (quest::get_data($flag_key)) {
            $client->Message(13, "You have already learned Unflinching Resolve Rank 2.");
            quest::removeitem(894, 1);  # Still remove the item
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