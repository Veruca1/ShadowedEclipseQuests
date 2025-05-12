my $signal_100_count = 0;  # Counter for signal 100 occurrences

sub EVENT_SPAWN {
    quest::settimer("spawn_1862", 3);  # Starts a repeating timer every 3 seconds
}

sub EVENT_TIMER {
    if ($timer eq "spawn_1862") {
        my @locations = (
            [-18.00, 620.00, 302.85, 130.00],
            [23.94, 679.67, 306.10, 194.00],
            [35.00, 745.00, 304.85, 260.00],
            [-19.00, 793.00, 304.85, 130.00],
            [6.00, 860.00, 306.70, 380.00],
        );

        # Depop any existing NPC 1862 to ensure only one is up
        quest::depopall(1862);

        # Select a random location
        my $random_loc = $locations[int(rand(@locations))];

        # Spawn NPC 1862 at the random location
        my ($x, $y, $z, $h) = @$random_loc;
        quest::spawn2(1862, 0, 0, $x, $y, $z, $h);
    }
}

sub EVENT_SIGNAL {
    if ($signal == 100) {
        $signal_100_count++;  # Increment the counter

        # If this is the 4th signal, perform the special event
        if ($signal_100_count == 4) {
            my $random_roll = int(rand(100));  # Generate a random number (0-99)

            if ($random_roll < 25) {  # 25% chance to spawn NPC 111185
                if (!quest::isnpcspawned(111185)) {  # Ensure only one is up at a time
                    quest::spawn2(111185, 0, 0, 6.00, 860.00, 306.70, 262.75);
                }
            } else {  # 75% chance to spawn multiple NPC 1861s
                quest::spawn2(1861, 0, 0, -18.00, 620.00, 302.85, 130.00);
                quest::spawn2(1861, 0, 0, 23.94, 679.67, 306.10, 194.00);
                quest::spawn2(1861, 0, 0, 35.00, 745.00, 304.85, 260.00);
                quest::spawn2(1861, 0, 0, -19.00, 793.00, 304.85, 130.00);
            }

            # Reset the signal counter after handling the 4th occurrence
            $signal_100_count = 0;
        }
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-voldemort_event_flag";  # The flag for the event
    my $cooldown_flag = "$char_id-voldemort_cooldown";  # Unique cooldown key
    my $cooldown_time = 600;  # 10-minute cooldown in seconds

    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            my $ready_link = quest::saylink("READY", 1);
            quest::whisper("You’ve done it. The ring... I can feel its connection. Voldemort can now be summoned, but be careful. He won’t go down easily. Say $ready_link when you are ready.");
        } else {
            quest::whisper("There’s nothing I can do yet. Marvolo Gaunt’s Ring is the key. Bring it to me, and I’ll help you face him.");
        }
    }

    if ($text =~ /ready/i) {
        if (quest::get_data($flag)) {
            # Check cooldown
            my $last_summon_time = quest::get_data($cooldown_flag);
            my $current_time = time();  # Get the current time in seconds

            if (!$last_summon_time || ($current_time - $last_summon_time) > $cooldown_time) {
                # No cooldown, proceed to summon Voldemort
                quest::set_data($cooldown_flag, $current_time);  # Update cooldown time
                quest::whisper("Then prepare yourself... He is coming.");
                start_voldemort_event();  # Start Voldemort event
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_summon_time);
                my $minutes = int($remaining_time / 60);
                my $seconds = $remaining_time % 60;
                quest::whisper("You must wait $minutes minutes and $seconds seconds before summoning him again.");
            }
        } else {
            quest::whisper("I can't summon him without the ring. Bring it to me, and we’ll face him together.");
        }
    }
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-voldemort_event_flag";  # The flag for the event
    my $cooldown_flag = "$char_id-voldemort_cooldown";  # Unique cooldown key
    my $cooldown_time = 600;  # 10-minute cooldown in seconds
    my $current_time = time();  # Get the current time in seconds

    if (plugin::check_handin(\%itemcount, 861 => 1)) {  # Marvolo Gaunt's Ring
        quest::set_data($flag, 1);  # Set flag indicating they can summon Voldemort

        # Check cooldown
        my $last_summon_time = quest::get_data($cooldown_flag);
        
        if (!$last_summon_time || ($current_time - $last_summon_time) > $cooldown_time) {
            # No cooldown, summon Voldemort immediately
            quest::set_data($cooldown_flag, $current_time);  # Set cooldown
            quest::whisper("The ring pulses with dark energy... He is coming.");
            start_voldemort_event();  # Spawn Voldemort immediately
        } else {
            # Cooldown still active, notify the player but still accept the ring
            my $remaining_time = $cooldown_time - ($current_time - $last_summon_time);
            my $minutes = int($remaining_time / 60);
            my $seconds = $remaining_time % 60;
            quest::whisper("You must wait $minutes minutes and $seconds seconds before summoning Voldemort again.");
        }
    } else {
        quest::whisper("That’s not what I need. If we’re going to face him, I need Marvolo Gaunt’s Ring.");
        plugin::return_items(\%itemcount);  # Return unrecognized items.
    }
}

sub start_voldemort_event {
    quest::whisper("The air grows cold as a sinister presence emerges...");
    quest::spawn2(1853, 0, 0, 22.58, 315.20, 354.67, 511.00);  # Spawns Voldemort at the correct location
}