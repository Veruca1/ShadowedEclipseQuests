sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $item_id = 9211;  # Item ID for the required item
    my $flag = "$char_id-robot_repair_flag";  # Create a unique flag identifier for this NPC and item

    # Check if the player handed in the required item
    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);
        plugin::Whisper("The repair kit has been accepted. You may now hail me to summon the repaired robot on a cooldown.");
    } else {
        # Return the item if it's not the correct one
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-robot_repair_flag";  # The flag for this NPC
    my $cooldown_key = "$char_id-robot_cooldown";  # A unique cooldown key
    my $cooldown_time = 180;  # 3-minute cooldown in seconds

    if ($text =~ /hail/i) {
        # Check if the flag for the item hand-in is set
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);
            my $current_time = time();  # Get the current time in seconds

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                # Check if NPC 36106 is already spawned
                if (!quest::isnpcspawned(36106)) {
                    plugin::Whisper("Summoning the repaired robot. Get ready!");
                    # Summon the NPC (ID: 36106)
                    quest::spawn2(36106, 0, 0, -148.06, -388.47, -38.84, 430.75);
                } else {
                    plugin::Whisper("The repaired robot is already active. Please wait until it has finished its task.");
                }
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                plugin::Whisper("You must wait a bit longer. Time remaining: " . int($remaining_time / 60) . " minutes, " . ($remaining_time % 60) . " seconds.");
            }
        } else {
            plugin::Whisper("You must first hand in the repair kit to summon the repaired robot.");
        }
    }
}
