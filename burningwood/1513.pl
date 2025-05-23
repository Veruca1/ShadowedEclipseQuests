my $item_id_chardok      = 395;                           # Item ID for granting access to Chardok
my $expedition_name_chardok = "Chardok's Push to the Future"; # Name of the expedition
my $min_players_chardok  = 1;                             # Minimum number of players
my $max_players_chardok  = 99;                            # Maximum number of players
my $dz_zone_chardok      = "chardok";                     # Valid zone name (Chardok)
my $dz_version_chardok   = 0;                             # Version of the dynamic zone (Chardok Version 0)
my $dz_duration_chardok  = 2592000;                       # Duration of the instance in seconds

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $chardok_access_key = "$char_id-chardok_access";  # Unique key for this character's access to Chardok

    # Check if the player hands in item 395 (Key to Chardok)
    if (plugin::check_handin(\%itemcount, $item_id_chardok => 1)) {
        # Set a data flag for the player indicating they handed in the key to Chardok
        quest::set_data($chardok_access_key, 1);
        
        # Grant the zone flag for Chardok (Zone ID 103)
        quest::set_zone_flag(103);

        # Confirmation message for granting access
        $client->Message(14, "Very well, you may enter at your own risk.");
        
        # Global announcement indicating the player now has access to Chardok
        quest::we(14, "$name has gained access to Chardok. Proceed with caution!");
    } else {
        # Return any incorrect items handed in
        plugin::return_items(\%itemcount);
    }
}



sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's ID
    my $chardok_access_key = "$char_id-chardok_access";  # Unique key for access to Chardok
    my $has_access_chardok = quest::get_data($chardok_access_key); # Check if the player has access to Chardok
    my $dz = $client->GetExpedition();     # Check if the player has an active expedition

    if ($text =~ /hail/i) {
        if ($dz && $dz->GetName() eq $expedition_name_chardok) {
            # Player already has an active expedition
            plugin::Whisper("You are already in an expedition for 'Chardok's Push to the Future.' If you're [" . quest::saylink("ready") . "] to enter, let me know.");
        } elsif ($has_access_chardok) {
            # Player has access but no active expedition, offer to create one
            plugin::Whisper("Welcome back! You already have access to 'Chardok's Push to the Future.' You can [" . quest::saylink("request") . "] a new expedition or let me know when you're [" . quest::saylink("ready") . "] to enter.");
        } else {
            # Player does not have access yet
            plugin::Whisper("Greetings, traveler. If you'd like to explore Chardok, you'll need to hand in the key to Chardok.");
        }
    }
    elsif ($text =~ /request/i) {
        if ($has_access_chardok) {
            # Create a new expedition for "Chardok's Push to the Future"
            my $dz = $client->CreateExpedition($dz_zone_chardok, $dz_version_chardok, $dz_duration_chardok, $expedition_name_chardok, $min_players_chardok, $max_players_chardok);
            
            if ($dz) {
                # Expedition created successfully
                plugin::Whisper("Expedition to 'Chardok's Push to the Future' created. Tell me when you're [" . quest::saylink("ready") . "] to enter.");
                $dz->AddReplayLockout(60);  # Add a 1-minute lockout (60 seconds)
            } else {
                # Error creating expedition
                plugin::Whisper("There was an error creating the expedition. Please try again.");
            }
        } else {
            # Deny access if the player hasn't handed in the required item
            plugin::Whisper("You do not have access to 'Chardok's Push to the Future.' Please hand in the key to Chardok first.");
        }
    }
    elsif ($text =~ /ready/i) {
        # Check if the player is in the expedition
        if ($dz && $dz->GetName() eq $expedition_name_chardok) {
            # Move the player to the dynamic zone (DZ)
            plugin::Whisper("Moving you to 'Chardok's Push to the Future'.");
            $client->MovePCDynamicZone($dz_zone_chardok, $dz_version_chardok);
        } else {
            # Player is not in the expedition
            plugin::Whisper("You are not part of the expedition or there is an error with your access.");
        }
    }
}