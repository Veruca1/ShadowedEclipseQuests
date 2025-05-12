my $item_id_v2      = 264;                        # Item ID for granting access (Version 2)
my $expedition_name_v2 = "The Final Showdown V2";  # Name of the expedition (Version 2)
my $min_players_v2  = 1;                          # Minimum number of players (Version 2)
my $max_players_v2  = 99;                         # Maximum number of players (Version 2)
my $dz_zone_v2      = "sebilis";                  # Valid zone name (Sebilis)
my $dz_version_v2   = 2;                          # Version of the dynamic zone (Sebilis Version 2)
my $dz_duration_v2  = 7200;                    # Duration of the instance (Version 2)


sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $sebilis_access_key_v2 = "$char_id-sebilis_access_v2";  # Unique key for this character (Version 2)

    # Check if the player hands in item 264 (Version 2)
    if (plugin::check_handin(\%itemcount, $item_id_v2 => 1)) {
        # Set a data flag for the player indicating they handed in item 264 (Version 2)
        quest::set_data($sebilis_access_key_v2, 1);
        
        # Confirmation message for granting access
        $client->Message(14, "Astonishing! With this, we are now able to locate Chronomancer Zarrin. Speak with me again if you'd like to finally put an end to this madness.");
    } else {
        # Return any incorrect items handed in
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's ID
    my $sebilis_access_key_v2 = "$char_id-sebilis_access_v2";  # Unique key for access (Version 2)
    my $has_access_v2 = quest::get_data($sebilis_access_key_v2); # Check if the player has access (Version 2)
    my $dz = $client->GetExpedition();     # Check if the player has an active expedition

    if ($text =~ /hail/i) {
        if ($dz && $dz->GetName() eq $expedition_name_v2) {
            # Player already has an active expedition
            plugin::Whisper("You are already in an expedition for 'The Final Showdown V2.' If you're [" . quest::saylink("ready") . "] to enter, let me know.");
        } elsif ($has_access_v2) {
            # Player has access but no active expedition, offer to create one
            plugin::Whisper("Welcome back! You already have access to 'The Final Showdown V2.' You can [" . quest::saylink("request") . "] a new expedition or let me know when you're [" . quest::saylink("ready") . "] to enter.");
        } else {
            # Player does not have access yet
            plugin::Whisper("Greetings, traveler. If you'd like to explore the final showdown, you'll need to hand in the proper item.");
        }
    }
    elsif ($text =~ /request/i) {
        if ($has_access_v2) {
            # Create a new expedition for "The Final Showdown V2"
            my $dz = $client->CreateExpedition($dz_zone_v2, $dz_version_v2, $dz_duration_v2, $expedition_name_v2, $min_players_v2, $max_players_v2);
            
            if ($dz) {
                # Expedition created successfully
                plugin::Whisper("Expedition to 'The Final Showdown V2' created. Tell me when you're [" . quest::saylink("ready") . "] to enter.");
                $dz->AddReplayLockout(60);  # Add a 1-minute lockout (60 seconds)
            } else {
                # Error creating expedition
                plugin::Whisper("There was an error creating the expedition. Please try again.");
            }
        } else {
            # Deny access if the player hasn't handed in the required item
            plugin::Whisper("You do not have access to 'The Final Showdown V2.' Please hand in the correct item first.");
        }
    }
    elsif ($text =~ /ready/i) {
        # Check if the player is in the expedition
        if ($dz && $dz->GetName() eq $expedition_name_v2) {
            # Move the player to the dynamic zone (DZ)
            plugin::Whisper("Moving you to 'The Final Showdown V2'.");
            $client->MovePCDynamicZone($dz_zone_v2, $dz_version_v2);
        } else {
            # Player is not in the expedition
            plugin::Whisper("You are not part of the expedition or there is an error with your access.");
        }
    }
}
