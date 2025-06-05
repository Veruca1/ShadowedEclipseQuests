sub EVENT_ITEM_CLICK {
    my $client = $entity_list->GetClientByID($userid);
    return unless $client;

    my $account_id = $client->AccountID();
    my $current_time = time();
    my $bucket_key = "FontOfFortune-" . $account_id;

    my $last_used_time = $client->GetBucket($bucket_key) || 0;

    if (($current_time - $last_used_time) >= 30) {
        $client->AddAlternateCurrencyValue(1, 5000);
        $client->SetBucket($bucket_key, $current_time);
        $client->Message(15, "A torrent of Donator Credits pours from the font: +5000!");
    } else {
        my $time_left = 30 - ($current_time - $last_used_time);
        $client->Message(15, "The font is still recharging. Try again in $time_left seconds.");
    }
}
