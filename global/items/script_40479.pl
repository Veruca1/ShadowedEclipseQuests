sub EVENT_ITEM_CLICK {
   # quest::debug("script_40479.pl: EVENT_ITEM_CLICK called");
    my $char_id = $client->CharacterID();

    
        quest::set_data("warp_donator_flag$char_id", 1);
     #  quest::debug("Item Click: Set warp_donator_flag$char_id to 1");
        $client->Message(15, "You have been granted permanent warp access!");
    
}

