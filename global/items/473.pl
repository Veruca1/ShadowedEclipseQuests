sub EVENT_ITEM_CLICK {
    my $char_id = $client->CharacterID();
    my $item_id = $itemid;  # Use the built-in item ID variable
    my $heirloom_key = "$char_id-$item_id";  # Use dynamic item ID for the key
    my $heirloom_kill_count = quest::get_data($heirloom_key) || 0;  # Retrieve stored kill count

    # Check if the clicked item is the heirloom (item ID 473) and handle the logic
    if ($item_id == 473) {
        if ($heirloom_kill_count > 0) {
            quest::whisper("Your heirloom has absorbed $heirloom_kill_count kills out of 750.");
        } else {
            quest::whisper("Your heirloom has not absorbed any kills yet.");
        }
    }
}
