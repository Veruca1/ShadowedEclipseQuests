sub EVENT_ITEM {
    my $char_id = $client->CharacterID();
    my $items_needed = { 265 => 1, 266 => 1, 267 => 1, 268 => 1 };
    my $flag = "$char_id-final_showdown_flag";

    # Check if player handed in all required items
    if (plugin::check_handin(\%itemcount, %$items_needed)) {
        quest::set_data($flag, 1);
        plugin::Whisper("You have proven your worth! Prepare for the final showdown.");

        # Check if NPC 1466 is already spawned
        if (!quest::isnpcspawned(1466)) {
            # Spawn NPC 1466 and depop this NPC (ID 1263) if spawn was successful
            my $spawned = quest::spawn2(1466, 0, 0, $x, $y, $z, $h);
            if ($spawned) {
                quest::depop();
            } else {
                plugin::Whisper("Something went wrong while summoning your opponent.");
            }
        } else {
            plugin::Whisper("The final opponent is already present. Prepare yourself!");
        }
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $flag = "$char_id-final_showdown_flag";
    my $cooldown_key = "$char_id-final_showdown_cooldown";
    my $cooldown_time = 600;  # 10 minutes in seconds

    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            my $last_hail_time = quest::get_data($cooldown_key);
            my $current_time = time();

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Reset cooldown timer
                quest::set_data($cooldown_key, $current_time);

                plugin::Whisper("Welcome back. Prepare for your next challenge!");

                # Check if NPC 1466 is already spawned
                if (!quest::isnpcspawned(1466)) {
                    # Attempt to spawn NPC 1466 at the current location of this NPC
                    my $spawned = quest::spawn2(1466, 0, 0, $x, $y, $z, $h);
                    if ($spawned) {
                        quest::depop();
                    } else {
                        plugin::Whisper("Something went wrong while summoning your opponent.");
                    }
                } else {
                    plugin::Whisper("The final opponent is already present. Prepare yourself!");
                }
            } else {
                # Cooldown active; notify player of remaining time
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                plugin::Whisper("You must wait a bit longer. Remaining time: " . int($remaining_time / 60) . " minutes.");
            }
        } else {
            plugin::Whisper("You must complete the item hand-in before I can help you.");
        }
    }
}