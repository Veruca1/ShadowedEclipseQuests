sub EVENT_ITEM_CLICK {
    my $required_aa_id = 449;  # Combat Agility Rank 4
    my $reward_aa_id   = 450;  # Combat Agility Rank 5
    my $flag_key       = "flag_858_" . $client->CharacterID();

    if ($client) {
        my $has_rank_4 = $client->GetAA($required_aa_id);
        my $has_rank_5 = $client->GetAA($reward_aa_id);

        if (!$has_rank_4) {
            $client->Message(13, "You must have Combat Agility Rank 4 before using this item.");
            quest::removeitem(858, 1);
            return;
        }

        if ($has_rank_5) {
            $client->Message(13, "You already have Combat Agility Rank 5.");
            quest::removeitem(858, 1);
            return;
        }

        if (quest::get_data($flag_key)) {
            $client->Message(13, "You have already used this item to gain Rank 5.");
            quest::removeitem(858, 1);
            return;
        }

        # Grant Rank 5
        $client->IncrementAA($reward_aa_id);
        $client->Message(15, "You feel a surge of combat agility as you master Rank 5!");

        quest::set_data($flag_key, 1);
        quest::removeitem(858, 1);
    }
}