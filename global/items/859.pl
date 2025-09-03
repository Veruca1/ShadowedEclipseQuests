sub EVENT_ITEM_CLICK {
    my $aa_id = 419;  # Planar Power Rank 9 AA ID
    my $flag_key = "flag_859_" . $client->CharacterID(); # Unique flag per character
    my $max_rank = 9;

    if ($client) {
        my $current_rank = $client->GetAA($aa_id);

        if ($current_rank >= $max_rank) {
            $client->Message(13, "You already have Planar Power Rank $current_rank or higher.");
            quest::removeitem(859, 1);  # Still remove the item
            return;
        }

        if (quest::get_data($flag_key)) {
            $client->Message(13, "You have already learned Planar Power Rank 9.");
            quest::removeitem(859, 1);  # Still remove the item
            return;
        }

        # Grant the AA
        $client->IncrementAA($aa_id);
        $client->Message(15, "You feel a surge of planar power!");

        # Set flag so they cannot gain it again
        quest::set_data($flag_key, 1);

        # Remove the item from inventory
        quest::removeitem(859, 1);
    }
}