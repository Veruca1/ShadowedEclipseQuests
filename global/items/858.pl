sub EVENT_ITEM_CLICK {
    my $aa_id = 125;  # Combat Agility Rank 5 AA ID
    my $flag_key = "flag_858_" . $client->CharacterID(); # Unique flag per character

    if ($client) {
        # Check if the player has already used the item
        if (quest::get_data($flag_key)) {
            $client->Message(13, "You have already learned Combat Agility Rank 5.");
            return;
        }

        # Grant the AA
        $client->IncrementAA($aa_id);
        $client->Message(15, "You feel a surge of combat agility!");

        # Set flag so they cannot gain it again
        quest::set_data($flag_key, 1);

        # Remove the item from inventory
        quest::removeitem(858, 1);
    }
}
