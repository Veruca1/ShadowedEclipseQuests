sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $item_id = 711;  # Charm of the Dragon (ID 711)
    my $flag = "$char_id-dragon_arena_flag";  # Create a unique flag identifier for this event
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();
    my $flagged = 0;

    # Check if the player handed in the required item (Charm of the Dragon)
    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        quest::set_data($flag, 1);
        plugin::Whisper("You have been flagged for the Dragon Arena Event. Hail me to begin the event.");
    } 
    # Check if the player hands in 4 of item ID 769
    elsif (plugin::check_handin(\%itemcount, 769 => 4)) {
        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(123);
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and group members on the same IP have earned access to Dragon Necropolis.");
            }
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(123);
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and raid members on the same IP have earned access to Dragon Necropolis.");
            }
        } else {
            $client->SetZoneFlag(123);
            quest::we(14, "$name has earned access to Dragon Necropolis.");
        }

        plugin::Whisper("You have been granted access to Dragon Necropolis.");
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-dragon_arena_flag";  # The flag for the event
    my $cooldown_key = "$char_id-dragon_arena_cooldown";  # Unique cooldown key
    my $cooldown_time = 90;  # 1 minute 30 seconds cooldown

    # Check if the player hails the NPC and has completed the hand-in
    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);
            my $current_time = time();  # Get the current time in seconds

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                plugin::Whisper("The event will begin now. Prepare yourself!");

                # Choose a random dragon from the list
                my @dragons = (120061, 120065, 120041, 120048, 120130, 120046, 120122, 120015,
                               120004, 120100, 120014, 120019, 120018, 120024, 120120, 120007,
                               120057, 120043, 120053, 120017, 120056, 120134, 120055, 120016,
                               120106, 120073, 120126, 120087, 120114, 120107, 120006, 120123,
                               120117, 120135, 120042, 120008, 120025);
                my $random_dragon = $dragons[int(rand(@dragons))];

                # Spawn the dragon at the specified location
                quest::spawn2($random_dragon, 0, 0, 576.76, 154.01, -277.41, 0.0);  # Spawn random dragon

                # Set the cooldown timer for the next event
                plugin::Whisper("The Dragon has been summoned. Fight well!");

                
                quest::settimer("dragon_arena_event", 90);
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                plugin::Whisper("You must wait a little longer before you can trigger this event again. Time remaining: " . int($remaining_time / 60) . " minutes.");
            }
        } else {
            plugin::Whisper("You must construct the Charm of the Dragon and hand it in before I can help you.");
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "dragon_arena_event") {
        # Stop the timer after the event ends
        quest::stoptimer("dragon_arena_event");

        # Shout a message to all players in the zone
        quest::shout("The Dragon Arena event has ended. You can participate again in 1 minute and 30 seconds.");

        # Reset the flag or any other logic for the cooldown
        my $char_id = $npc->GetID();  # Fallback if no client is found
        quest::set_data("$char_id-dragon_arena_flag", 0);
    }
}
