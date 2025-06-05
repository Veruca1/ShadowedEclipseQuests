sub EVENT_ITEM_CLICK {
    my $client = $entity_list->GetClientByID($userid);
    return unless $client;

    my $current_time = time();
    my $account_id = $client->AccountID();
    my $bucket_key = "DonatorCrystal-" . $account_id;
    my $last_used_time = $client->GetBucket($bucket_key) || 0;

    if (($current_time - $last_used_time) >= 3600) {
        $client->AddAlternateCurrencyValue(1, 10);
        $client->Message(15, "A radiant glow surrounds you as 10 Donator Credits are infused into your account.");
        $client->SetBucket($bucket_key, $current_time);
    } else {
        my $time_left = 3600 - ($current_time - $last_used_time);
        my $minutes_left = int($time_left / 60);
        my $seconds_left = $time_left % 60;
        $client->Message(15, "The power is not ready. Try again in $minutes_left minutes and $seconds_left seconds.");
    }
}
