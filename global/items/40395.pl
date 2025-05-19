sub EVENT_ITEM_CLICK {
    if ($client) {
        my $char_id = $client->CharacterID();
        my $flag_40395 = "${char_id}_40395_click";  # Unique databucket key for this item click

        # Check if this title has already been granted
        if (quest::get_data($flag_40395)) {
            $client->Message(13, "You have already claimed the title 'The Arm of the Coven'.");
            return;
        }

        # Grant the title and set the databucket
        $client->SetTitleSuffix("The Arm of the Coven", 1);
        $client->NotifyNewTitlesAvailable();
        $client->Message(15, "You have earned the title 'The Arm of the Coven'!");
        quest::we(13, "$name has been recognized as 'The Arm of the Coven'!");
        quest::discordsend("titles", "$name has earned the title of The Arm of the Coven!");

        # Set the databucket to flag they've used the item
        quest::set_data($flag_40395, 1);

        # Remove the item after use
        $client->RemoveItem(40395);
    }
}