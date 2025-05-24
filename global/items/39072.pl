sub EVENT_ITEM_CLICK {
    return unless defined($client) && $client->IsClient();

    my $char_id = $client->CharacterID();
    return unless defined($char_id);

    my $flag_key = "echo_checkpoint_unlock_" . $char_id;

    # Check if player has the item
    if (quest::countitem(39072) >= 1) {
        # Remove the item regardless of flag state
        quest::removeitem(39072, 1);
    } else {
        $client->Message(15, "You do not have the required item (Checkpoint Stone).");
        return;
    }

    # Check if already unlocked
    my $existing = quest::get_data($flag_key);
    if (defined($existing) && $existing == 1) {
        $client->Message(15, "The echo checkpoint is already unlocked. The stone crumbles in your hands — you no longer need it.");
        return;
    }

    # Set the unlock flag
    quest::set_data($flag_key, 1);
    $client->Message(15, "You feel a shift in the air... a checkpoint has been unlocked in Echo Caverns.");
}