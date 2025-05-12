sub EVENT_KILLED_MERIT {
    return unless $client;
    my $char_id = $client->CharacterID();
    my $delete_waves = $char_id . "-wave_number";
    my $title_flag = "wave_title_" . $char_id;

    quest::delete_data($delete_waves);

    # Check if the player already has the title
    if (!quest::get_data($title_flag)) {
        quest::set_data($title_flag, 1); # Flag player as having received the title
        $client->SetTitleSuffix("Wave Baby", 1);   # Correct: grant suffix title
        $client->NotifyNewTitlesAvailable();       # Refresh available titles

        $client->Message(14, "You have finished the final wave and earned a new title! You have been reset to Wave 0.");
        quest::we(13, "$name has defeated the wave event and earned the title Wave Baby!");
        quest::discordsend("titles", "$name has earned the title of Wave Baby!");
    }
}