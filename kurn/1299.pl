sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-item_31687_flag";  # Unique flag identifier for this NPC
    my $trigger_item = 31687;

    # Check if the player hands in item 31687
    if (plugin::check_handin(\%itemcount, $trigger_item => 1)) {
        # Check if the player has already completed the hand-in
        if (quest::get_data($flag)) {
            plugin::Whisper("You have already handed in this item and cannot do so again.");
        } else {
            # Set the flag indicating the player has completed the hand-in
            quest::set_data($flag, 1);

            # Send a yellow message to all players nearby
            quest::ze(14, "The dead snake begins to twitch and move...");

            # Wait for 10 seconds before spawning the new NPC
            quest::settimer("spawn_npc", 10);
        }

        # Do not return the item
        # quest::summonitem($trigger_item);  # This line has been removed
    } else {
        # Return items if the handin is not correct
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc") {
        # Stop the timer to prevent it from repeating
        quest::stoptimer("spawn_npc");

        # Get the location of the current NPC (1299)
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Spawn NPC 1298 at the same location
        quest::spawn2(1298, 0, 0, $x, $y, $z, $h);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-item_31687_flag";  # The flag for the item hand-in
    my $cooldown_key = "$char_id-item_31687_hail_cd";  # A unique cooldown key
    my $cooldown_time = 300;  # 5-minute cooldown in seconds
    my $current_time = time();  # Current time in seconds

    if ($text =~ /hail/i) {
        # Check if the flag for the item hand-in is set
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                # Spawn NPC 1298 again
                my $x = $npc->GetX();
                my $y = $npc->GetY();
                my $z = $npc->GetZ();
                my $h = $npc->GetHeading();
                quest::spawn2(1298, 0, 0, $x, $y, $z, $h);

                plugin::Whisper("The dead snake has risen again!");
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                my $minutes = int($remaining_time / 60);
                my $seconds = $remaining_time % 60;
                plugin::Whisper("You must wait $minutes minutes and $seconds seconds before you can do this again.");
            }
        } else {
            plugin::Whisper("You must first hand in the item before I can help you.");
        }
    }
}
