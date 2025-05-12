sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $flag = "$char_id-rat_event_flag";
    my $cooldown_key = "$char_id-rat_event_cooldown";
    my $cooldown_time = 1200;  # 20 minutes in seconds

    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            plugin::Whisper("The scent of cheese still lingers... If you're ready, say " . quest::saylink("READY") . " and let the hunt begin.");
        } else {
            plugin::Whisper("I can’t help you unless you have something enticing…");
        }
    }

    if ($text =~ /READY/i) {
        my $last_attempt_time = quest::get_data($cooldown_key);
        my $current_time = time();

        if (!$last_attempt_time || ($current_time - $last_attempt_time) > $cooldown_time) {
            quest::set_data($cooldown_key, $current_time);
            quest::set_data($flag, 1);

            plugin::Whisper("The Big Cheese is in play... something stirs nearby!");

            # Check if NPC 1812 is already spawned
            if (!quest::isnpcspawned(1812)) {
                # Spawn NPC 1812 at the specified location
                quest::spawn2(1812, 0, 0, -601.46, -498.02, -244.08, 404.00);
            } else {
                plugin::Whisper("The Big Cheese is already here. Wait for it to leave before trying again.");
            }
        } else {
            my $time_left = $cooldown_time - ($current_time - $last_attempt_time);
            my $minutes_left = int($time_left / 60);
            my $seconds_left = $time_left % 60;

            plugin::Whisper("The Big Cheese is still settling... You'll need to wait $minutes_left minutes and $seconds_left seconds.");
        }
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 732 => 1)) {  # Changed item to 732 (The Big Cheese)
        quest::set_data($client->CharacterID() . "-rat_event_flag", 1);
        plugin::Whisper("Ah, now we can begin. When you're ready, say 'READY' and we’ll see what emerges...");
    } else {
        plugin::return_items(\%itemcount);
    }
}
