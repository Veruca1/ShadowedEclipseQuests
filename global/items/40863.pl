sub EVENT_ITEM_CLICK {
	# Ensure this item can only be clicked in Maiden's Eye (zone ID 173)
	if ($zoneid != 173) {
		$client->Message(315, "You sense this item will only function in Maiden's Eye.");
		return;
	}

	# Roll for success (50% chance)
	my $roll = int(rand(100)) + 1;

	if ($roll <= 50) {
		# Success: Set the zone flag for Akheva Ruins (zone ID 179) using client IP logic
		my $clicker_ip = $client->GetIP();
		my $group = $client->GetGroup();
		my $raid  = $client->GetRaid();
		my $flagged = 0;

		if ($group) {
			for (my $i = 0; $i < $group->GroupCount(); $i++) {
				my $member = $group->GetMember($i);
				next unless $member;
				if ($member->GetIP() == $clicker_ip) {
					$member->SetZoneFlag(179);
					$flagged = 1;
				}
			}
			quest::we(14, "$name and group members on the same IP have earned access to Akheva Ruins!") if $flagged;
		} elsif ($raid) {
			for (my $i = 0; $i < $raid->RaidCount(); $i++) {
				my $member = $raid->GetMember($i);
				next unless $member;
				if ($member->GetIP() == $clicker_ip) {
					$member->SetZoneFlag(179);
					$flagged = 1;
				}
			}
			quest::we(14, "$name and raid members on the same IP have earned access to Akheva Ruins!") if $flagged;
		} else {
			$client->SetZoneFlag(179);
			quest::we(14, "$name has earned access to Akheva Ruins!");
		}

		$client->Message(315, "The artifact glows briefly before crumbling to dust.");
	} else {
		# Failure: Item crumbles with no effect
		$client->Message(315, "The artifact pulses... then crumbles into useless dust.");
	}

	# Always remove one item
	quest::removeitem(40863, 1);
}