sub EVENT_ITEM_CLICK {
    my $clicked_check = $client->GetBucket("-portOn");
    if ($itemid == 59943) {
        if (!$clicked_check) {
            $client->MovePC(21, 597, -1148, -39, 260); # Commonlands teleport
            $client->SetBucket("-portOn", 1, 1);       # 1 second cooldown for testing
        } else {
            quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-portOn")) . "] to use again");
        }
    }
}
