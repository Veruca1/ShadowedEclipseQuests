sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-dragonbones_flag";  # Unique flag identifier for this NPC
    my $trigger_item = 31685;

    # Check if the player hands in the Paradoxical Dragon Bone
    if (plugin::check_handin(\%itemcount, $trigger_item => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);

        # Send a message to the player
        $client->Message(15, "I don't think you should have done that...");
        
        # Spawn Jaled Dar immediately
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();
        quest::spawn2(1293, 0, 0, $x, $y, $z, $h);
    } else {
        # Return items if the handin is not correct
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-dragonbones_flag";  # The flag for this NPC
    my $cooldown_key = "$char_id-dragonbones_hail_cd";  # A unique cooldown key
    my $cooldown_time = 600;  # 10-minute cooldown in seconds
    my $current_time = time();  # Current time in seconds

    if ($text =~ /hail/i) {
        # Check if the flag for the item hand-in is set
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                # Spawn Jaled Dar
                my $x = $npc->GetX();
                my $y = $npc->GetY();
                my $z = $npc->GetZ();
                my $h = $npc->GetHeading();
                quest::spawn2(1293, 0, 0, $x, $y, $z, $h);

                plugin::Whisper("Jaled Dar has risen once more!");
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                my $minutes = int($remaining_time / 60);
                my $seconds = $remaining_time % 60;
                plugin::Whisper("You must wait $minutes minutes and $seconds seconds before you can do this again.");
            }
        } else {
            plugin::Whisper("You must first hand in the Paradoxical Dragon Bone before I can help you.");
        }
    }
}
