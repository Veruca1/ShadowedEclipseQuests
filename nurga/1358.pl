sub EVENT_SAY {
    if ($text =~ /hail/i) {
        plugin::Whisper("Are people annoying you? Then I can send you to an " . quest::saylink("instance") . " if you like.");
    }
    
    if ($text =~ /instance/i) {
        
        my $group = $client->GetGroup();    
        
        # Unpack the list into variables
        my $zone_id = "nurga";
        my $x = -1786.09;
        my $y = -2202.16;
        my $z = 3.33;
        
        my $char_id = $client->CharacterID();  # Get the character's ID 
        
        if ($group) {     
            if ($zone_id eq "nurga") {
                plugin::Whisper("Cya!");
                 $client->SendToInstance("group", $zone_id, 1, $x, $y, $z, 0, "nurga", 14400);
            }
        } else {
            if ($zone_id eq "nurga") {
                plugin::Whisper("Cya!");
                $client->SendToInstance("solo", $zone_id, 1, $x, $y, $z, 0, "nurga", 14400);
            }
        }
    }
}