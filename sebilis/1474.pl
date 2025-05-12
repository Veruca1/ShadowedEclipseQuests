sub EVENT_SAY {
    if ($text =~ /hail/i) {
        plugin::Whisper("Are people annoying you? Then I can send you to an " . quest::saylink("instance") . " if you like.");
    }
    
    if ($text =~ /instance/i) {
        
        my $group = $client->GetGroup();    
        
        # Unpack the list into variables
        my $zone_id = "sebilis";
        my $x = 0.01;
        my $y = 257.11;
        my $z = 40.16;
        
        my $char_id = $client->CharacterID();  # Get the character's ID 
        
        if ($group) {     
            if ($zone_id eq "sebilis") {
                plugin::Whisper("Cya!");
                 $client->SendToInstance("group", $zone_id, 0, $x, $y, $z, 0, "sebilis", 14400);
            }
        } else {
            if ($zone_id eq "sebilis") {
                plugin::Whisper("Cya!");
                $client->SendToInstance("solo", $zone_id, 0, $x, $y, $z, 0, "sebilis", 14400);
            }
        }
    }
}