sub EVENT_ITEM_CLICK {            
    my $aa_id = 1549;  # Unflinching Resolve Rank 1 AA ID 
    my $flag_key = "flag_836_" . $client->CharacterID(); # Unique flag per character
    my $max_rank = 1;

    if ($client) {
        my $current_rank = $client->GetAA($aa_id);

        if ($current_rank >= $max_rank) {
            $client->Message(13, "You already have Unflinching Resolve Rank $current_rank or higher.");
            quest::removeitem(836, 1);  # Still consume the item
            return;
        }

        if (quest::get_data($flag_key)) {
            $client->Message(13, "You have already learned Unflinching Resolve Rank 1.");
            quest::removeitem(836, 1);  # Still consume the item
            return;
        }

        # Grant the AA
        $client->IncrementAA($aa_id);
        $client->Message(15, "You feel a surge of unflinching resolve!");

        # Set flag so they cannot gain it again
        quest::set_data($flag_key, 1);

        # Remove the item from inventory
        quest::removeitem(836, 1);
    }
}