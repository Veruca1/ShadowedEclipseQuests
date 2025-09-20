sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-zarrinspirit_flag";  # Unique flag identifier for this NPC

    # Check if the player handed in the required items (Item IDs 429, 430, 431, 432)
    if (plugin::check_handin(\%itemcount, 429 => 1, 430 => 1, 431 => 1, 432 => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);
        
        plugin::Whisper("You have completed the task. You may now hail me to proceed.");
    } else {
        # Return the items if they're not correct
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-zarrinspirit_flag";  # The flag for this NPC
    my $cooldown_key = "$char_id-zarrinspirit_hail_cd";  # A unique cooldown key
    my $cooldown_time = 60;  # 1-minute cooldown in seconds
    my $current_time = time();  # Current time in seconds

    # Check if the flag for the item hand-in is set
    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                plugin::Whisper("The event is triggered. ZarrinSpirit has appeared.");
                #quest::spawn2(1581, 0, 0, -688.00, 318.62, 469.68, 128.75);  # Spawn NPC 1581 (ZarrinSpirit)
		quest::spawn2(1592, 0, 0, -559.25, 191.06, 445.07, 504.74);
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                my $minutes = int($remaining_time / 60);
                my $seconds = $remaining_time % 60;
                plugin::Whisper("You must wait $minutes minutes and $seconds seconds before you can hail me again.");
            }
        } else {
            plugin::Whisper("You must complete the hand-in before I can help you.");
        }
    }
}
