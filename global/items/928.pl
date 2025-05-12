sub EVENT_ITEM_CLICK {
    my $title_text = "The Chosen One";
    my $flag_key = "title_928_" . $client->CharacterID(); # Unique flag per character for this title

    if ($client) {
        # Check if the player has already used the item
        if (quest::get_data($flag_key)) {
            $client->Message(13, "You have already earned the title '$title_text' and cannot use this again.");
            return;
        }

        # Grant the suffix title to this specific client
        $client->SetTitleSuffix($title_text, 1);
        $client->NotifyNewTitlesAvailable();
        $client->Message(15, "You now bear the title '$title_text'!");

        # Global announcement and Discord integration
        quest::we(13, "$name has earned the title $title_text!");
        quest::discordsend("titles", "$name has earned the title of $title_text!");

        # Set flag so they cannot gain it again
        quest::set_data($flag_key, 1);

        # Remove the item from inventory
        if (plugin::check_hasitem($client, 928)) {
            quest::removeitem(928, 1);
        }
    }
}
