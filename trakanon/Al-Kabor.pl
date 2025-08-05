my $item_id = 263;                        # Item ID for granting access
my $expedition_name = "The Real Old Sebilis";   # Name of the expedition
my $min_players     = 1;                        # Minimum number of players
my $max_players     = 99;                       # Maximum number of players
my $dz_zone         = "sebilis";                # Valid zone name (Sebilis)
my $dz_version      = 1;                        # Version of the dynamic zone (Sebilis Version 1)
my $dz_duration     = 7200;                     # Duration of the instance

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's ID 
    my $sebilis_access_key = "$char_id-sebilis_access"; # Unique key for this character

    # Check if the player hands in item 263
    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        # Set a data flag for the player indicating they handed in item 263
        quest::set_data($sebilis_access_key, 1);
        
        # Confirmation message for granting access
        quest::whisper("Thank you! You now have access to explore the alternate version of Sebilis. Speak with me again if you'd like to investigate.");
    } else {
        # Return any incorrect items handed in
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's ID
    my $sebilis_access_key = "$char_id-sebilis_access";  # Unique key for access
    my $has_access = quest::get_data($sebilis_access_key); # Check if the player has access
    my $dz = $client->GetExpedition();     # Check if the player has an active expedition

    if ($text =~ /hail/i) {
        if ($dz && $dz->GetName() eq $expedition_name) {
            # Player already has an active expedition
            quest::whisper("You are already in an expedition for 'The Real Old Sebilis.' If you're [" . quest::saylink("ready") . "] to enter, let me know.");
        } elsif ($has_access) {
            # Player has access but no active expedition, offer to create one
            quest::whisper("Welcome back! You already have access to 'The Real Old Sebilis.' You can [" . quest::saylink("request") . "] a new expedition or let me know when you're [" . quest::saylink("ready") . "] to enter.");
        } else {
            # Player does not have access yet
            quest::whisper("Greetings, traveler. If you'd like to explore the alternate version of Sebilis, you'll need to hand in the proper item.");
        }
    }
    elsif ($text =~ /request/i) {
        if ($has_access) {
            # Create a new expedition for "The Real Old Sebilis"
            my $dz = $client->CreateExpedition($dz_zone, $dz_version, $dz_duration, $expedition_name, $min_players, $max_players);
            
            if ($dz) {
                # Expedition created successfully
                quest::whisper("Expedition to 'The Real Old Sebilis' created. Tell me when you're [" . quest::saylink("ready") . "] to enter.");
            } else {
                # Error creating expedition
                quest::whisper("There was an error creating the expedition. Please try again.");
            }
        } else {
            # Deny access if the player hasn't handed in the required item
            quest::whisper("You do not have access to 'The Real Old Sebilis.' Please hand in the correct item first.");
        }
    }
    elsif ($text =~ /ready/i) {
        # Check if the player is in the expedition
        if ($dz && $dz->GetName() eq $expedition_name) {
            # Move the player to the dynamic zone (DZ)
            quest::whisper("Moving you to 'The Real Old Sebilis'.");
            $client->MovePCDynamicZone($dz_zone, $dz_version);
        } else {
            # Player is not in the expedition
            quest::whisper("You are not part of the expedition or there is an error with your access.");
        }
    }
}
