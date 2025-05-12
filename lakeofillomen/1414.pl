sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-egg_flag";  # Unique flag identifier for this NPC

    # Check if the player handed in the required item (Item ID 33114)
    if (plugin::check_handin(\%itemcount, 33114 => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);

        plugin::Whisper("The egg cracks as it resonates with your offering. It seems attuned to you now.");
    } else {
        # Return the items if they're not correct
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-egg_flag";  # The flag for this NPC
    my $cooldown_key = "$char_id-egg_hail_cd";  # A unique cooldown key
    my $cooldown_time = 600;  # 10-minute cooldown in seconds
    my $current_time = time();  # Current time in seconds

    # Check if the flag for the item hand-in is set
    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                plugin::Whisper("The air shimmers as Garudon emerges...");
                # Spawn NPC 109107 (Garudon) at the egg's current location
                my $x = $npc->GetX();
                my $y = $npc->GetY();
                my $z = $npc->GetZ();
                my $h = $npc->GetHeading();
                quest::spawn2(109107, 0, 0, $x, $y, $z, $h);

                # Depop the current NPC (1414) and set a repop timer for 1 minute
                $npc->Depop(60);
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
