sub EVENT_SPAWN {
    # Spawn NPC ID 1427 at location 0, 0, 0 with heading 0
    quest::spawn2(1427, 0, 0, 0, 0, 0, 0);
}

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        plugin::Whisper("Are people annoying you? Then I can send you to an " . quest::saylink("instance") . " if you like.");
    }
    
    if ($text =~ /instance/i) {
        
        my $group = $client->GetGroup();    
        
        # Unpack the list into variables
        my $zone_id = "befallen";
        my $x = 30.07;
        my $y = -76.67;
        my $z = 4.06;
        
        my $char_id = $client->CharacterID();  # Get the character's ID 
        
        if ($group) {     
            if ($zone_id eq "befallen") {
                plugin::Whisper("Cya!");
                 $client->SendToInstance("group", $zone_id, 0, $x, $y, $z, 0, "befallen", 14400);
            }
        } else {
            if ($zone_id eq "befallen") {
                plugin::Whisper("Cya!");
                $client->SendToInstance("solo", $zone_id, 0, $x, $y, $z, 0, "befallen", 14400);
            }
        }
    }
}