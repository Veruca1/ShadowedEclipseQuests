# New Item ID for Veeshan's Peak access
my $item_id = 424;
my $expedition_name = "Veeshan's Peak Expedition";
my $min_players = 1;
my $max_players = 99;
my $dz_zone = "veeshan";
my $dz_version = 0;
my $dz_duration = 2592000;

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();
    my $veeshans_peak_access_key = "$char_id-veeshans_peak_access";
    my $bot_limit_flag = "$char_id-bot-limit";

    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        my $clicker_ip = $client->GetIP();
        my $group = $client->GetGroup();
        my $raid = $client->GetRaid();

        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    my $member_char_id = $member->CharacterID();
                    quest::set_data("$member_char_id-veeshans_peak_access", 1);
                    $member->SetZoneFlag(108);
                    $member->Message(14, "Thank you! You now have access to Veeshan's Peak. Speak with me again if you'd like to investigate.");
                    $member->SetBotSpawnLimit(5);
                    quest::set_data("$member_char_id-bot-limit", 5);
                }
            }
            quest::we(14, "$name and group members on the same IP have earned access to Veeshan's Peak and upgraded their bot spawn limit to 5!");
        }
        elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    my $member_char_id = $member->CharacterID();
                    quest::set_data("$member_char_id-veeshans_peak_access", 1);
                    $member->SetZoneFlag(108);
                    $member->Message(14, "Thank you! You now have access to Veeshan's Peak. Speak with me again if you'd like to investigate.");
                    $member->SetBotSpawnLimit(5);
                    quest::set_data("$member_char_id-bot-limit", 5);
                }
            }
            quest::we(14, "$name and raid members on the same IP have earned access to Veeshan's Peak and upgraded their bot spawn limit to 5!");
        }
        else {
            quest::set_data($veeshans_peak_access_key, 1);
            $client->SetZoneFlag(108);
            $client->Message(14, "Thank you! You now have access to Veeshan's Peak. Speak with me again if you'd like to investigate.");
            $client->SetBotSpawnLimit(5);
            quest::we(14, "$name has earned access to Veeshan's Peak and upgraded their bot spawn limit to 5!");
            quest::set_data($bot_limit_flag, 5);
        }
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's ID
    my $veeshans_peak_access_key = "$char_id-veeshans_peak_access";  # Unique key for access
    my $has_access = quest::get_data($veeshans_peak_access_key); # Check if the player has access
    my $dz = $client->GetExpedition();     # Check if the player has an active expedition

    if ($text =~ /hail/i) {
        if ($dz && $dz->GetName() eq $expedition_name) {
            # Player already has an active expedition
            plugin::Whisper("You are already in an expedition for 'Veeshan's Peak Expedition.' If you're [" . quest::saylink("ready") . "] to enter, let me know.");
        } elsif ($has_access) {
            # Player has access but no active expedition, offer to create one
            plugin::Whisper("Welcome back! You already have access to 'Veeshan's Peak Expedition.' You can [" . quest::saylink("request") . "] a new expedition or let me know when you're [" . quest::saylink("ready") . "] to enter.");
        } else {
            # Player does not have access yet
            plugin::Whisper("Greetings, traveler. If you'd like to explore Veeshan's Peak, you'll need to hand in the proper item.");
        }
    }
    elsif ($text =~ /request/i) {
        if ($has_access) {
            # Create a new expedition for "Veeshan's Peak Expedition"
            my $dz = $client->CreateExpedition($dz_zone, $dz_version, $dz_duration, $expedition_name, $min_players, $max_players);
            
            if ($dz) {
                # Expedition created successfully
                plugin::Whisper("Expedition to 'Veeshan's Peak Expedition' created. Tell me when you're [" . quest::saylink("ready") . "] to enter.");
                $dz->AddReplayLockout(0);  # Set the lockout to 0 (no lockout)
            } else {
                # Error creating expedition
                plugin::Whisper("There was an error creating the expedition. Please try again.");
            }
        } else {
            # Deny access if the player hasn't handed in the required item
            plugin::Whisper("You do not have access to 'Veeshan's Peak Expedition.' Please hand in the correct item first.");
        }
    }
    elsif ($text =~ /ready/i) {
        # Check if the player is in the expedition
        if ($dz && $dz->GetName() eq $expedition_name) {
            # Move the player to the dynamic zone (DZ)
            plugin::Whisper("Moving you to 'Veeshan's Peak Expedition.'");
            $client->MovePCDynamicZone($dz_zone, $dz_version);
        } else {
            # Player is not in the expedition
            plugin::Whisper("You are not part of the expedition or there is an error with your access.");
        }
    }
}