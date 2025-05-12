sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $item_id = 405;  # Coin item ID
    my $flag = "$char_id-chardok_access_flag";  # Flag identifier for this hand-in

    # Check if the player handed in the required item (Coin) and set the flag if it's a first-time hand-in
    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        quest::set_data($flag, 1);
        plugin::Whisper("You have done well. You may now simply hail me to proceed in the future.");
    }

    # Return any other items handed in
    plugin::return_items(\%itemcount);
}

sub EVENT_SAY { 
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-chardok_access_flag";  # Flag for the hand-in
    my $cooldown_key = "$char_id-chardok_hail_cooldown";  # Hail cooldown key
    my $cooldown_time = 600;  # 10-minute cooldown for hailing
    my $npc_id = 1523;  # NPC ID to spawn

    # Check if the player attempts to hail the NPC
    if ($text =~ /hail/i) {
        # Ensure the player has completed the item hand-in
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);
            my $current_time = time();

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Check if NPC 1523 is already up
                if (!quest::isnpcspawned($npc_id)) {
                    # Update the hail time to the current time
                    quest::set_data($cooldown_key, $current_time);

                    plugin::Whisper("Welcome back. Let me trigger the event for you.");

                    # Spawn NPC 1523 at the specified location
                    quest::spawn2($npc_id, 0, 0, -292.63, -559.24, -161.37, 126.50);
                } else {
                    plugin::Whisper("The event NPC is already active. Please wait until it is no longer present.");
                }
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                plugin::Whisper("You must wait a little longer before you can trigger this event again. Time remaining: " . int($remaining_time / 60) . " minutes.");
            }
        } else {
            plugin::Whisper("You must complete the hand-in before I can help you.");
        }
    }
}
