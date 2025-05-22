sub EVENT_ITEM_CLICK {
    # Check if the client object is valid and is a player
    return unless defined($client) && $client->IsClient();

    my $char_id = $client->CharacterID();
    # Check if $char_id is valid and defined
    return unless defined($char_id);

    my $flag_key = "echo_checkpoint_unlock_" . $char_id;

    # Always try to remove the item (A Checkpoint Stone - 39072)
    if (quest::countitem(39072) >= 1) {
        # Remove the item (A Checkpoint Stone) from the player's inventory
        if (!quest::removeitem(39072, 1)) {
            $client->Message(15, "The echo checkpoint is already unlocked. The stone crumbles in your hands — you no longer need it.");
        return;
        }
    } else {
        $client->Message(15, "You do not have the required item (Checkpoint Stone).");
        return;
    }

    # Retrieve the existing checkpoint unlock flag
    my $existing = quest::get_data($flag_key);
    
    # If already unlocked
    if (defined($existing) && $existing == 1) {
        $client->Message(15, "The echo checkpoint is already unlocked. The stone crumbles in your hands — you no longer need it.");
        return;
    }

    # Set the checkpoint unlock flag
    quest::set_data($flag_key, 1);

    # Notify the player that the checkpoint has been unlocked
    $client->Message(15, "You feel a shift in the air... a checkpoint has been unlocked in Echo Caverns.");
}