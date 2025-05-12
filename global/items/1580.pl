sub EVENT_ITEM_CLICK {
    my $clicked_check = $client->GetBucket("-portOn");
    if($itemid == 1580) {
        if (!$clicked_check) {
           $client->MovePC(54,-2229.71,-2156.88,21.09,449.50);
           $client->SetBucket("-portOn", 1, 1);
        }else{
            quest::message(315, "You must wait [" .  quest::secondstotime($client->GetBucketRemaining("-portOn")) . "] to use again");
            
        }
    }
}