sub EVENT_ITEM_CLICK {
    my $clicked_check = $client->GetBucket("-portOn");
    if ($itemid == 28368) {
        if (!$clicked_check) {            
           $client->MovePC(86, 9597.68, 771.96, 1063.64, 383.75);
           $client->SetBucket("-portOn", 1, 1);  # Cooldown set to 1 second
        } else {
            quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-portOn")) . "] to use again");
        }
    }
}
