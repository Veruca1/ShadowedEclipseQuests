sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-sirencycle_flag";  # Unique flag identifier for this NPC

    # Check if the player handed in the required item (Item ID 638)
    if (plugin::check_handin(\%itemcount, 638 => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);
        
        plugin::Whisper("You have completed the task. You may now hail me to proceed with the Siren Cycle.");
    } else {
        # Return the items if they're not correct
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-sirencycle_flag";  # The flag for this NPC
    my $cooldown_key = "$char_id-sirencycle_hail_cd";  # A unique cooldown key
    my $cooldown_time = 1800;  # 30-minute cooldown in seconds
    my $current_time = time();  # Current time in seconds

    # Check if the flag for the item hand-in is set
    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                plugin::Whisper("The Siren Cycle is triggered. Look across the way and prepare yourself!");

                # NPC IDs to spawn (1724 and 1725 switched)
                my @npc_ids = (1725, 1724, 1726, 1727, 1728, 1729);

                # Locations to spawn NPCs
                my @locations = (
                    { x => -90.00,  y => -63.00,  z => -103.03, heading => 30.00 },  # Now for NPC 1725
                    { x => -143.00, y => -49.00,  z => -116.03, heading => 35.00 },  # Now for NPC 1724
                    { x => 32.00,   y => -43.00,  z => -116.03, heading => 493.00 },
                    { x => 7.00,    y => -54.00,  z => -109.03, heading => 510.00 },
                    { x => -16.00,  y => -64.00,  z => -103.03, heading => 507.00 },
                    { x => -121.00, y => -58.00,  z => -109.03, heading => 31.00 }
                );

                # Spawn NPCs at the specified locations
                for my $i (0 .. $#npc_ids) {
                    my $npc_id = $npc_ids[$i];
                    my $loc = $locations[$i];

                    # Check if the NPC is already spawned
                    if (!quest::isnpcspawned($npc_id)) {
                        # Spawn the NPC
                        quest::spawn2($npc_id, 0, 0, $loc->{x}, $loc->{y}, $loc->{z}, $loc->{heading});
                    } else {
                        plugin::Whisper("NPC $npc_id is already spawned. Skipping duplicate spawn.");
                    }
                }
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                my $minutes = int($remaining_time / 60);
                my $seconds = $remaining_time % 60;
                plugin::Whisper("You must wait $minutes minutes and $seconds seconds before you can hail me again.");
            }
        } else {
            plugin::Whisper("You must complete the hand-in before I can help you with the Siren Cycle.");
        }
    }
}