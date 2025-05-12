sub EVENT_ITEM_CLICK {
    my $clicked_check = $client->GetBucket("-portOn");
    if($itemid == 147862) {
        if (!$clicked_check) {            
           $client->MovePC(86,9597.68,771.96,1063.64,383.75);
           $client->SetBucket("-portOn", 1, 120);
        }else{
            quest::message(315, "You must wait [" .  quest::secondstotime($client->GetBucketRemaining("-portOn")) . "] to use again");
            
        }
    }
}