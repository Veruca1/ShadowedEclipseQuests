sub EVENT_ITEM_CLICK {
    my $clicked_check = $client->GetBucket("-portOn");

    # Assuming $itemid is available in this event and holds the clicked item's ID
    if ($itemid == 9209) {
        if (!$clicked_check) {
            $client->MovePC(189, 18, -147, 20, 0);  # Zone 189 with coords
            $client->SetBucket("-portOn", 1, 120);  # 2 min cooldown
        } else {
            quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-portOn")) . "] to use again");
        }
    }
}