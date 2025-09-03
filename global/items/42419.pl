sub EVENT_ITEM_CLICK {
	# Only allow use in The Deep (zone ID 164)
	if ($zoneid != 164) {
		$client->Message(315, "Nothing happens.");
		return;
	}

	# Grant Maiden's Eye zone flag (zone ID 173) using client IP logic
	my $clicker_ip = $client->GetIP();
	my $group = $client->GetGroup();
	my $raid  = $client->GetRaid();
	my $flagged = 0;

	if ($group) {
		for (my $i = 0; $i < $group->GroupCount(); $i++) {
			my $member = $group->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(173);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and group members on the same IP have earned access to Maiden's Eye.") if $flagged;
	} elsif ($raid) {
		for (my $i = 0; $i < $raid->RaidCount(); $i++) {
			my $member = $raid->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(173);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and raid members on the same IP have earned access to Maiden's Eye.") if $flagged;
	} else {
		$client->SetZoneFlag(173);
		quest::we(14, "$name has earned access to Maiden's Eye.");
	}

	# Always remove one item
	quest::removeitem(42419, 1);
}