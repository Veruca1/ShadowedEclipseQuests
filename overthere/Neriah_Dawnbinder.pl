sub EVENT_SAY {
	if ($text=~/hail/i) {
		# Offer the task/quest when hailed
		my $task_id = 15;  # Task ID for Howling Stones access
		quest::whisper("Greetings, adventurer. If you wish to brave the haunted halls of Howling Stones, you must prove yourself worthy. The Chronomancer has really messed with time here. We need to undo some of his meddling. Once you have taken care of this list, come back to me.");
		quest::assigntask($task_id);  # Assign task ID 15
	}
}

sub EVENT_ITEM {
	my $howling_stones_item = 32460;   # Item required for Howling Stones access
	my $love_letter_item    = 32471;   # Love Letter from Drusella to Venril

	my $clicker_ip = $client->GetIP();
	my $group = $client->GetGroup();
	my $raid = $client->GetRaid();
	my $flagged = 0;

	if (plugin::check_handin(\%itemcount, $howling_stones_item => 1)) {
		if ($group) {
			for (my $i = 0; $i < $group->GroupCount(); $i++) {
				my $member = $group->GetMember($i);
				next unless $member;
				if ($member->GetIP() == $clicker_ip) {
					$member->SetZoneFlag(105);
					$member->Message(15, "You now have access to Howling Stones. Tread carefully, for it is filled with great danger.");
					$member->AssignTask(16);
					$flagged = 1;
				}
			}
		 if ($flagged) {
			 quest::we(14, "$name and group members on the same IP have earned access to Howling Stones!");
		 }
		} elsif ($raid) {
			for (my $i = 0; $i < $raid->RaidCount(); $i++) {
				my $member = $raid->GetMember($i);
				next unless $member;
				if ($member->GetIP() == $clicker_ip) {
					$member->SetZoneFlag(105);
					$member->Message(15, "You now have access to Howling Stones. Tread carefully, for it is filled with great danger.");
					$member->AssignTask(16);
					$flagged = 1;
				}
			}
			if ($flagged) {
				quest::we(14, "$name and raid members on the same IP have earned access to Howling Stones!");
			}
		} else {
			$client->SetZoneFlag(105);
			quest::we(14, "$name has earned access to Howling Stones!");
			quest::whisper("You now have access to Howling Stones. Tread carefully, for it is filled with great danger.");
			quest::assigntask(16);
		}

		quest::exp(1000);
		quest::summonitem($howling_stones_item);  # Return the item, used later
	}
	elsif (plugin::check_handin(\%itemcount, $love_letter_item => 1)) {
		$client->SetTitleSuffix("Tomb Raider", 1);
		$client->NotifyNewTitlesAvailable();
		quest::whisper("What a significant find! This letter reveals secrets long buried. For such a discovery, you shall be known as 'Tomb Raider'.");
		quest::we(13, "$name has uncovered ancient secrets and earned the title Tomb Raider!");
		quest::discordsend("titles", "$name has earned the title of Tomb Raider!");
		quest::summonitem(54269);
	}

	plugin::return_items(\%itemcount);
}