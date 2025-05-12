sub EVENT_ITEM_CLICK {
    my $clicked_check = $client->GetBucket("-portOn");
    if($itemid == 9209) {
        if (!$clicked_check) {
           $client->MovePC(189,18,-147,20,0);
           $client->SetBucket("-portOn", 1, 120);
        }else{
            quest::message(315, "You must wait [" .  quest::secondstotime($client->GetBucketRemaining("-portOn")) . "] to use again");
            
        }
    }
}