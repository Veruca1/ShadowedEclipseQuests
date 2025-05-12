sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $item_id = 9207;  # Item ID for the required item
    my $flag = "$char_id-189491_flag";  # Create a unique flag identifier for this NPC and item

    # Check if the player handed in the required item
    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);
        plugin::Whisper("You have proven yourself. You may now hail me to summon the event on a cooldown.");
    } else {
        # Return the item if it's not the correct one
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-189491_flag";  # The flag for this NPC
    my $cooldown_key = "$char_id-189491_cooldown";  # A unique cooldown key
    my $cooldown_time = 30;  # 3-minute cooldown in seconds

    if ($text =~ /hail/i) {
        # Check if the flag for the item hand-in is set
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);
            my $current_time = time();  # Get the current time in seconds

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                # Check if NPC 189491 is already spawned
                if (!quest::isnpcspawned(189491)) {
                    plugin::Whisper("Summoning the event. Be prepared!");
                    # Summon the NPC (ID: 189491)
                    quest::spawn2(189491, 0, 0, -511.13, 717.24, -17.74, 124.75);  # Replace with actual spawn coordinates
                } else {
                    plugin::Whisper("The event is already ongoing. Please wait until it has ended.");
                }
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                plugin::Whisper("You must wait a bit longer. Time remaining: " . int($remaining_time / 60) . " minutes, " . ($remaining_time % 60) . " seconds.");
            }
        } else {
            plugin::Whisper("You must first complete the hand-in to summon the event.");
        }
    }
}
