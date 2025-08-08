sub EVENT_SAY {
	my $char_id = $client->CharacterID();
	my $flag = "$char_id-spider_event_flag";
	my $cooldown_key = "$char_id-spider_event_cooldown";
	my $cooldown_time = 30;  # 30 seconds

	if ($text =~ /hail/i) {
		if (quest::get_data($flag)) {
			my $ready_link = quest::silent_saylink("ready");
			quest::whisper("The bones of the surrounding scaled ones stir with the power of these carapaces... Are you $ready_link for the ritual?");
		} else {
			quest::whisper("I cannot do anything for you until I have 4 Pristine Phase Spider Carapaces.");
		}
	} elsif ($text =~ /READY/i) {
		my $last_attempt_time = quest::get_data($cooldown_key);
		my $current_time = time();

		if (!$last_attempt_time || ($current_time - $last_attempt_time) > $cooldown_time) {
			quest::set_data($cooldown_key, $current_time);
			quest::set_data($flag, 1);

			quest::whisper("The bones of the surrounding scaled ones draw power from the velium cores used to create these carapaces. The results await you in these three huts!");

			if (!quest::isnpcspawned(123015)) {
				quest::spawn2(123015, 0, 0, 1031.48, 911.95, 11.97, 218.75);
			}

			if (!quest::isnpcspawned(1798)) {
				quest::spawn2(1798, 0, 0, 679.23, 651.42, 11.97, 89.25);
			}

			if (!quest::isnpcspawned(1797)) {
				quest::spawn2(1797, 0, 0, 374.72, 725.64, 11.29, 0.50);
			}
		} else {
			my $time_left = quest::secondstotime($cooldown_time - ($current_time - $last_attempt_time));
			quest::whisper("The bones of the surrounding scaled ones still draw power from the velium cores. Their energy must settle before the ritual can be performed again. You must wait $time_left.");
		}
	}
}

sub EVENT_ITEM {
	my $char_id = $client->CharacterID();
	my $flag = "$char_id-spider_event_flag";

	if (plugin::check_handin(\%itemcount, 726 => 4)) {
		quest::set_data($flag, 1);
		quest::whisper("You have gathered the carapaces. The bones of the surrounding scaled ones stir with power. Hail me when you are ready.");
	}

	plugin::return_items(\%itemcount);
}