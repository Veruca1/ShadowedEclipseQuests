sub EVENT_ITEM_CLICK {
    my $clicked_check = $client->GetBucket("-pohate");
    if($itemid == 28117) {
        if (!$clicked_check) {
           $client->MovePC(186,-393,655,3, 0);
           $client->SetBucket("-pohate", 1, 1);
        }else{
            quest::message(315, "You must wait [" .  quest::secondstotime($client->GetBucketRemaining("-pohate")) . "] to use again");

        }
    }
}