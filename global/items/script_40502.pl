sub EVENT_ITEM_CLICK {
    my $client = $entity_list->GetClientByID($userid);
    return unless $client;

    # Get the current time
    my $current_time = time();

    # Get the account ID to use in the bucket key
    my $account_id = $client->AccountID();

    # Generate a unique bucket key using the account ID
    my $bucket_key = "Donator Sack-" . $account_id;

    # Retrieve the last time the item was used from the "Donator Sack" bucket associated with the account
    my $last_used_time = $client->GetBucket($bucket_key) || 0;

    # Check if one hour (3600 seconds) has passed since the last use
    if (($current_time - $last_used_time) >= 3600) {
        # Grant the Donator Credit
        $client->AddAlternateCurrencyValue(1, 1);
        $client->Message(15, "You shook the box, and a Donator Credit drops out!");

        # Update the last used time to the current time in the "Donator Sack" bucket for the account
        $client->SetBucket($bucket_key, $current_time);

    } else {
        # Calculate how much time is left on the cooldown
        my $time_left = 3600 - ($current_time - $last_used_time);
        my $minutes_left = int($time_left / 60);
        my $seconds_left = $time_left % 60;

        # Inform the player that the item is still on cooldown
        $client->Message(15, "It is not time. Try again in $minutes_left minutes and $seconds_left seconds.");
    }
}