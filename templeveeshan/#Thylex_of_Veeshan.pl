sub EVENT_SAY {
	my $char_id = $client->CharacterID();
	my $vulak_flag = "${char_id}-vulak_spawn_flag";
	my $vulak_lock = $client->GetBucket("-vulak_lockout");

	if ($text =~ /hail/i) {
		quest::whisper("You approach the ancient altar of awakening. Should you wish to face Vulak`Aerr, the final test of might, you must first prove yourself.");

		if (quest::get_data($vulak_flag)) {
			if (!$vulak_lock) {
				my $vulak_link = quest::silent_saylink("Vulak");
				quest::whisper("You have proven yourself. When you are ready, say $vulak_link to summon Vulak`Aerr.");
			} else {
				my $time_left = quest::secondstotime($client->GetBucketRemaining("-vulak_lockout"));
				quest::whisper("You must wait $time_left to summon Vulak again.");
			}
		}
	} elsif ($text =~ /vulak/i) {
		if (quest::get_data($vulak_flag)) {
			if (!$vulak_lock) {
				quest::whisper("So be it. Vulak`Aerr awakens!");
				$client->SetBucket("-vulak_lockout", 1, 30); # 30 second lockout

				quest::spawn2(1275, 0, 0, -739.4, 517.2, 121, 510);
			} else {
				my $time_left = quest::secondstotime($client->GetBucketRemaining("-vulak_lockout"));
				quest::whisper("The ritual energies are still stabilizing. Time remaining: $time_left");
			}
		} else {
			quest::whisper("You are not yet worthy to summon Vulak`Aerr.");
		}
	}
}

sub EVENT_ITEM {
	my $char_id = $client->CharacterID();
	my $vulak_flag = "${char_id}-vulak_spawn_flag";
	my $vulak_link = quest::saylink("VULAK", 1, "Vulak");

	if (plugin::check_handin(\%itemcount, 30582 => 1)) {
		quest::set_data($vulak_flag, 1);
		quest::whisper("You have proven your strength. When you are ready, say $vulak_link to summon Vulak`Aerr.");
	}

	plugin::return_items(\%itemcount);
}
