sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-eye_flag";  # Unique flag identifier for the Pupiless Eye hand-in

    # Check if the player handed in the required item (Item ID 401)
    if (plugin::check_handin(\%itemcount, 401 => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);

        plugin::Whisper("The Pupiless Eye resonates with your offering. It seems attuned to you now.");
    } else {
        # Return the items if they're not correct
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-eye_flag";  # The flag for the Pupiless Eye hand-in
    my $cooldown_key = "$char_id-eye_cooldown";  # Unique cooldown key
    my $cooldown_time = 240;  # 4-minute cooldown in seconds
    my $npc_id = 1509;  # NPC ID for the All Seeing Eye

    if ($text =~ /hail/i) {
        # Check if the player has completed the hand-in (i.e., flag is set)
        if (quest::get_data($flag)) {
            my $current_time = time();  # Get the current time in seconds
            my $last_hail_time = quest::get_data($cooldown_key);  # Get the last hail time

            # Check if cooldown is over or not
            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time and set the cooldown
                quest::set_data($cooldown_key, $current_time);

                # Check if NPC 1509 is already spawned
                if (!quest::isnpcspawned($npc_id)) {
                    # Spawn the All Seeing Eye at the specified location
                    quest::spawn2($npc_id, 0, 0, -1712.07, -352.15, 1220.81, 103.25);

                    plugin::Whisper("You have summoned the All Seeing Eye!");
                } else {
                    plugin::Whisper("The All Seeing Eye is already here.");
                }
            } else {
                # Cooldown still active, notify the player
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
