sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $flag = "$char_id-rat_event_flag";
    my $cooldown_key = "$char_id-rat_event_cooldown";
    my $cooldown_time = 600;  # 10 minutes in seconds

    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            plugin::Whisper("A rat trap wouldn't squeak... Are you ready? If so, click " . quest::saylink("READY") . " and prepare yourself.");
        } else {
            plugin::Whisper("I can't do anything for you unless I have some rat bait.");
        }
    }

    if ($text =~ /READY/i) {
        my $last_attempt_time = quest::get_data($cooldown_key);
        my $current_time = time();

        if (!$last_attempt_time || ($current_time - $last_attempt_time) > $cooldown_time) {
            quest::set_data($cooldown_key, $current_time);
            quest::set_data($flag, 1);

            plugin::Whisper("The smell of rat bait fills the air... something stirs in the shadows!");

            my @npc_ids = (1805, 1806, 1807, 1808, 1809, 1810);  # Updated rat NPC IDs
            my @spawn_locs = (
                [-1209.55, 216.75, -177.28, 261.75],
                [-1463.41, 374.16, -256.31, 175.25],
                [-1408.96, 338.75, -256.31, 175.25],
                [-1422.87, 391.46, -257.14, 206.75],
                [-1460.55, 336.85, -257.13, 141.25],
                [-1279.05, 675.48, -257.15, 270.50],
                [-1311.16, 678.79, -257.14, 274.50],
                [-1293.16, 730.42, -257.15, 272.75],
                [-1102.02, 978.16, -257.14, 350.00],
                [-1094.81, 928.85, -257.15, 364.25],
                [-1141.70, 951.66, -257.14, 341.75],
                [-1005.21, 951.22, -257.15, 381.25],
                [-1793.80, 194.46, -257.58, 131.75],
                [-1759.09, 102.69, -258.38, 45.75],
                [-1723.74, 170.21, -259.65, 76.50],
                [-1829.00, 70.68, -257.13, 38.00],
                [-1830.64, -173.60, -257.14, 390.25],
                [-1879.16, -28.18, -257.14, 107.25],
                [-1612.86, -166.22, -257.14, 376.75],
                [-1689.69, -195.36, -257.14, 395.00],
                [-1624.73, -275.25, -257.14, 417.75],
                [-1601.89, -278.77, -257.12, 439.25],
                [-1423.89, -371.55, -257.14, 401.50],
                [-1492.44, -381.00, -257.13, 434.00],
                [-1046.53, -161.27, -257.13, 406.75],
                [-1054.72, -206.83, -257.14, 388.75],
                [-972.98, -196.47, -257.14, 393.25],
                [-875.32, -395.79, -257.15, 12.25],
                [-810.31, -362.79, -257.14, 456.50],
                [-768.19, -517.33, -257.15, 442.25],
                [-731.99, -439.61, -257.14, 418.00],
                [-689.28, -349.07, -256.13, 321.00],
                [-637.38, -432.92, -247.12, 392.75],
                [-675.90, -498.51, -247.66, 446.25],
                [-631.02, -581.83, -247.77, 469.75]
            );

            # Spawn random NPCs at random locations
            for my $loc (@spawn_locs) {
                my $npc_id = $npc_ids[int(rand(@npc_ids))];  # Pick a random NPC from the list
                quest::spawn2($npc_id, 0, 0, @$loc);
            }
        } else {
            my $time_left = $cooldown_time - ($current_time - $last_attempt_time);
            my $minutes_left = int($time_left / 60);
            my $seconds_left = $time_left % 60;

            plugin::Whisper("The rats are still digesting their last meal... You'll need to wait $minutes_left minutes and $seconds_left seconds.");
        }
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 728 => 1)) {
        quest::set_data($client->CharacterID() . "-rat_event_flag", 1);
        plugin::Whisper("Ah, now we can get started. When you're ready, just say 'READY' and we’ll see what scurries out...");
    } else {
        plugin::return_items(\%itemcount);
    }
}

