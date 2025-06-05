sub EVENT_ITEM_CLICK {
    my $item_id = $item->GetID();  # Gets the clicked item ID
    my $char_id = $client->CharacterID();

    if ($item_id == 123456) {  # Replace 123456 with your warp donator item ID
        quest::set_data("warp_donator_flag$char_id", 1);
        $client->Message(15, "You have been granted permanent warp access!");
    }
}
