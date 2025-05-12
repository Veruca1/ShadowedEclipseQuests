sub EVENT_SAY {
    if ($text =~ /hail/i) {
        plugin::Whisper("Are people annoying you? Then I can send you to an " . quest::saylink("instance") . " if you like.");
    }
    
    if ($text =~ /instance/i) {
        
        my $group = $client->GetGroup();    
        
        # Unpack the list into variables
        my $zone_id = "veksar";
        my $x = -51.98;
        my $y = -514.91;
        my $z = 49.77;
        
        my $char_id = $client->CharacterID();  # Get the character's ID 
        
        if ($group) {     
            if ($zone_id eq "veksar") {
                plugin::Whisper("Cya!");
                 $client->SendToInstance("group", $zone_id, 0, $x, $y, $z, 0, "veksar", 14400);
            }
        } else {
            if ($zone_id eq "veksar") {
                plugin::Whisper("Cya!");
                $client->SendToInstance("solo", $zone_id, 0, $x, $y, $z, 0, "veksar", 14400);
            }
        }
    }
}