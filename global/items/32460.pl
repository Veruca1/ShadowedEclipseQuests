sub EVENT_ITEM_CLICK {
    my $clicked_check = $client->GetBucket("-portOn");
    if($itemid == 32460) {  # Updated item ID
        if (!$clicked_check) {            
            # Move to Charasis zone (ID 105) with specified coordinates and heading
            $client->MovePC(105, 0.00, 0.00, 4.75, 0.00);
            $client->SetBucket("-portOn", 1, 120);
        } else {
            quest::message(315, "You must wait [" . quest::secondstotime($client->GetBucketRemaining("-portOn")) . "] to use again");
        }
    }
}
