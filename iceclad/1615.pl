sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-polar_kraken_flag";  # Unique flag identifier for this NPC

    # Check if the player handed in the required item (Item ID: 30053)
    if (plugin::check_handin(\%itemcount, 30053 => 1)) {
        # Set the flag indicating the player has completed the hand-in
        quest::set_data($flag, 1);

        plugin::Whisper("The icy depths stir... You may now hail me to summon the Polar Kraken.");
    } else {
        # Return the items if they're not correct
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-polar_kraken_flag";  # The flag for this NPC
    my $cooldown_key = "$char_id-polar_kraken_hail_cd";  # A unique cooldown key
    my $cooldown_time = 60;  # 1-minute cooldown in seconds
    my $current_time = time();  # Current time in seconds
    my $spawned_npc_id = 110131; # Polar Kraken NPC ID

    # Check if the flag for the item hand-in is set
    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Ensure the Polar Kraken is not already spawned
                if (!quest::isnpcspawned($spawned_npc_id)) {
                    # Update the hail time to the current time
                    quest::set_data($cooldown_key, $current_time);

                    plugin::Whisper("The icy depths rumble as the Polar Kraken emerges!");
                    # Spawn the Polar Kraken at the NPC's current location
                    my $x = $npc->GetX();
                    my $y = $npc->GetY();
                    my $z = $npc->GetZ();
                    my $h = $npc->GetHeading();
                    quest::spawn2($spawned_npc_id, 0, 0, $x, $y, $z, $h);
                } else {
                    plugin::Whisper("The Polar Kraken is already roaming these lands. Wait for its departure before summoning it again.");
                }
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                my $minutes = int($remaining_time / 60);
                my $seconds = $remaining_time % 60;
                plugin::Whisper("You must wait $minutes minutes and $seconds seconds before you can hail me again.");
            }
        } else {
            plugin::Whisper("You must obtain the Stormfeather Talons to prove your worth.");
        }
    }
}
