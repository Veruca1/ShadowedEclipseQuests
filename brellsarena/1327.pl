sub EVENT_SAY {
    if ($text =~ /hail/i) {
        plugin::Whisper("Are people annoying you? Then I can send you to an " . quest::saylink("instance") . " if you like.");
    }
    
    if ($text =~ /instance/i) {
        
        my $group = $client->GetGroup();    
        
        # Unpack the list into variables
        my $zone_id = "brellsarena";
        my $x = -46.12;
        my $y = -213.20;
        my $z = -9.43;
        
        my $char_id = $client->CharacterID();  # Get the character's ID 
        
        if ($group) {     
            if ($zone_id eq "brellsarena") {
                plugin::Whisper("Cya!");
                 $client->SendToInstance("group", $zone_id, 0, $x, $y, $z, 0, "brellsarena", 7200);
            }
        } else {
            if ($zone_id eq "brellsarena") {
                plugin::Whisper("Cya!");
                $client->SendToInstance("solo", $zone_id, 0, $x, $y, $z, 0, "brellsarenab", 7200);
            }
        }
    }
}