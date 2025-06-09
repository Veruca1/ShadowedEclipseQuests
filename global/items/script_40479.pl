sub EVENT_ITEM_CLICK {
    my $char_id = $client->CharacterID();

    if ($item_id == 40840) {
        quest::set_data("warp_donator_flag$char_id", 1);
        $client->Message(15, "You have been granted permanent warp access!");
    }
}

