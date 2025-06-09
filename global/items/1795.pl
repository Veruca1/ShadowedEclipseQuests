sub EVENT_ITEM_CLICK {
    my $char_id = $client->CharacterID();
    my $key = "paludal_boss_unlock_" . $char_id;
    my $flag = quest::get_data($key);

    if (!defined($flag) || $flag != 1) {
        quest::set_data($key, 1);
        $client->Message(15, "You feel a shift in your destiny. You are now attuned to the End Boss.");
    } else {
        $client->Message(15, "You are already attuned.");
    }

    $client->RemoveItem(1795, 1);  # Remove the item after use
}