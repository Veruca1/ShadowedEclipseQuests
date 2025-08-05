sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-horizon_flag";  # Create a unique flag identifier for the hand-in

    # Check if the player has given the correct items (IDs 33046, 33101, 33102)
    if (plugin::check_handin(\%itemcount, 33046 => 1, 33101 => 1, 33102 => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);

        # Spawn NPC 1408 at the current location of NPC 1407
        quest::spawn2(1408, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());

        # Depop NPC 1407
        #quest::depop();
    } else {
        # If the items are not correct, return the items
        quest::say("I don't need these items.");
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-horizon_flag";  # The flag for this NPC
    my $cooldown_key = "$char_id-horizon_cooldown";  # A unique cooldown key
    my $cooldown_time = 1200;  # 20-minute cooldown in seconds

    # Check if the flag for the item hand-in is set
    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);
            my $current_time = time();  # Get the current time in seconds

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                quest::whisper("Welcome back. Let me trigger the event for you.");
                
                # Spawn NPC 1408 at the specified location after the hail
                quest::spawn2(1408, 0, 0, -247.07, -117.75, -10.98, 511.50);  # NPC 1408 with new location and heading
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                quest::whisper("You must wait a little longer before you can trigger this event again. Time remaining: " . int($remaining_time / 60) . " minutes.");
            }
        } else {
            quest::whisper("You must complete the hand-in before I can help you.");
        }
    }
}
