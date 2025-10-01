sub EVENT_ITEM_CLICK {
    return unless $client && $client->IsClient();
    quest::debug("40478 script running");
    my $zone_id = $zoneid;
    my $zone_name = $zonesn;
    my $account_id = $client->AccountID();
    my $bucket_key = "RepopCooldown-$account_id-$itemid";
    my $current_time = time();
    my $last_used = $client->GetBucket($bucket_key) || 0;

    # Array of forbidden zone IDs
    my @forbidden_zones = (138); # Add more as needed
    my $is_forbidden = 0;
    foreach my $forbidden_zone (@forbidden_zones) {
        if ($zone_id == $forbidden_zone) {
            $is_forbidden = 1;
            last;
        }
    }

    if ($is_forbidden || $zone_name eq "poknowledge") {
        $client->Message(315, "You cannot use this item in this zone.");
        return;
    }

    if (($current_time - $last_used) >= 300) {
        quest::clearspawntimers();
        quest::repopzone();
        $client->SetBucket($bucket_key, $current_time);
        $client->Message(21, "Mobs in this zone have been repopped. Timers have been cleared, resummon custom pets if you want them to cast things.");
    } else {
        my $time_left = 300 - ($current_time - $last_used);
        my $minutes = int($time_left / 60);
        my $seconds = $time_left % 60;
        $client->Message(15, "You must wait $minutes minute(s) and $seconds second(s) before using this item again.");
    }
}
