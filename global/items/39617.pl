# quests/global/items/9209.pl

sub EVENT_ITEM_CLICK {
    my $char_id = $client->CharacterID();
    my $flag_key = "${char_id}_void_flag";  # Unique key for this zone flagging

    my $cooldown_check = $client->GetBucket("voida_click_cd");

    if (!$cooldown_check) {
        # Only flag once
        if (!quest::get_data($flag_key)) {
            quest::set_zone_flag(459);  # Set zone flag for The Void
            quest::set_data($flag_key, 1); # Mark that user is flagged, so it doesn't happen again
        }

        # Move player to zone 459 at default coords
        $client->MovePC(459, 0, 0, 0, 0);

        # Set cooldown bucket for 60 seconds
        $client->SetBucket("voida_click_cd", 1, 60);

    } else {
        quest::message(315, "The shard hums, but remains inert. Wait [" . quest::secondstotime($client->GetBucketRemaining("voida_click_cd")) . "] before using it again.");
    }
}