sub EVENT_SAY {
    if ($text =~ /hail/i) {
        plugin::Whisper("Are people annoying you? Then I can send you to an " . quest::saylink("instance") . " if you like.");
    }
    
    if ($text =~ /instance/i) {
        
        my $group = $client->GetGroup();    
        
        # Updated zone and location details
        my $zone_id = "frozenshadow";
        my $x = 199.17;
        my $y = 187.49;
        my $z = -2.32;
        
        my $char_id = $client->CharacterID();  # Get the character's ID 
        
        if ($group) {     
            if ($zone_id eq "frozenshadow") {
                plugin::Whisper("Cya!");
                $client->SendToInstance("group", $zone_id, 0, $x, $y, $z, 0, "frozenshadow", 14400);
            }
        } else {
            if ($zone_id eq "frozenshadow") {
                plugin::Whisper("Cya!");
                $client->SendToInstance("solo", $zone_id, 0, $x, $y, $z, 0, "frozenshadow", 14400);
            }
        }
    }
}
