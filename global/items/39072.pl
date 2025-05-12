sub EVENT_ITEM_CLICK {
    # Check if the client object is valid and is a player
    return unless defined($client) && $client->IsClient();

    my $char_id = $client->CharacterID();
    # Check if $char_id is valid and defined
    return unless defined($char_id);

    my $flag_key = "echo_checkpoint_unlock_" . $char_id;

    # Retrieve the existing checkpoint unlock flag
    my $existing = quest::get_data($flag_key);
    
    # Ensure the flag exists and is either undefined or 0 (i.e., not unlocked yet)
    if (defined($existing) && $existing == 1) {
        # If already unlocked, notify the player
        $client->Message(15, "The echo checkpoint is already unlocked.");
        return;
    }

    # Set the checkpoint unlock flag
    if (!quest::set_data($flag_key, 1)) {
        # If the flag couldn't be set, notify the player
        $client->Message(15, "An error occurred while unlocking the checkpoint. Please try again.");
        return;
    }

    # Notify the player that the checkpoint has been unlocked
    $client->Message(15, "You feel a shift in the air... a checkpoint has been unlocked in Echo Caverns.");

    # Check if the player has the item (A Checkpoint Stone - 39072) in their inventory
    if (quest::countitem(39072) >= 1) {
        # Remove the item (A Checkpoint Stone) from the player's inventory
        if (!quest::removeitem(39072, 1)) {
            # If item couldn't be removed, notify the player
            $client->Message(15, "An error occurred while removing the Checkpoint Stone. Please try again.");
            return;
        }
    } else {
        # If the player doesn't have the item, notify them
        $client->Message(15, "You do not have the required item (Checkpoint Stone).");
        return;
    }
}