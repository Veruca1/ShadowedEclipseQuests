sub EVENT_SAY {
	my $char_id = $client->CharacterID();
	my $flag = "$char_id-jaleddar_event_flag";
	my $cooldown_key = "$char_id-jaleddar_event_cooldown";
	my $cooldown_time = 30;  # 30 seconds

	if ($text =~ /hail/i) {
		if (quest::get_data($flag)) {
			my $ready_link = quest::silent_saylink("ready");
			quest::whisper("You are $ready_link to face the challenge. You will have 5 minutes to kill 40 spiders AFTER Jaled Dar is defeated. If you fail, the event will end, and you will need to wait for the cooldown to reset before trying again.");
		} else {
			quest::whisper("I cannot do anything for you until you bring me the Jaled Dar's Tomb Key.");
		}
	}

	# Check for the "READY" response from the player
	elsif ($text =~ /READY/i) {
		my $last_attempt_time = quest::get_data($cooldown_key);
		my $current_time = time();

		if (!$last_attempt_time || ($current_time - $last_attempt_time) > $cooldown_time) {
			quest::set_data($cooldown_key, $current_time);  # Update the cooldown time
			quest::set_data($flag, 0);  # Optionally reset the event flag after starting

			quest::whisper("The event begins now! You have 5 minutes to kill 40 spiders AFTER Jaled Dar is defeated. If you fail, the event will end, and you will need to wait for the cooldown before attempting again.");

			# Spawn NPC 1803 at the given location
			quest::spawn2(1803, 0, 0, -1248.88, 897.22, 10.70, 104.75);
		} else {
			my $time_left = quest::secondstotime($cooldown_time - ($current_time - $last_attempt_time));

			quest::whisper("The event cannot be performed again so soon. You must wait $time_left.");
		}
	}
}

sub EVENT_ITEM {
	# Check if the player has handed in the Jaled Dar's Tomb Key (item 28060)
	if (plugin::check_handin(\%itemcount, 28060 => 1)) {
		my $char_id = $client->CharacterID();
		my $flag = "$char_id-jaleddar_event_flag";

		quest::set_data($flag, 1);  # Flag the player for the event
		quest::whisper("You have been marked for the Jaled Dar's event. Speak to me when you are ready to begin.");
		
		# Return the Jaled Dar's Tomb Key (item 28060) back to the player
		quest::summonitem(28060);
	}

	plugin::return_items(\%itemcount);
}