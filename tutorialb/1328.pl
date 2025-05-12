sub EVENT_SAY {
    if ($text =~ /hail/i) {
        plugin::Whisper("If you would like your own private instance of this place just let me know. Then I can send you to an " . quest::saylink("instance") . " if you like.");
    }
    
    if ($text =~ /instance/i) {
        
        my $group = $client->GetGroup();    
        
        # Unpack the list into variables
        my $zone_id = "tutorialb";
        my $x = -119.37;
        my $y = -147.04;
        my $z = 19.13;
        
        my $char_id = $client->CharacterID();  # Get the character's ID 
        
        if ($group) {     
            if ($zone_id eq "tutorialb") {
                plugin::Whisper("Cya!");
                 $client->SendToInstance("group", $zone_id, 0, $x, $y, $z, 0, "tutorialb", 7200);
            }
        } else {
            if ($zone_id eq "tutorialb") {
                plugin::Whisper("Cya!");
                $client->SendToInstance("solo", $zone_id, 0, $x, $y, $z, 0, "tutorialb", 7200);
            }
        }
    }
}