sub EVENT_ITEM_CLICK {    
	# Grant The Deep zone flag (zone ID 164) using client IP logic
	my $clicker_ip = $client->GetIP();
	my $group = $client->GetGroup();
	my $raid  = $client->GetRaid();
	my $flagged = 0;

	if ($group) {
		for (my $i = 0; $i < $group->GroupCount(); $i++) {
			my $member = $group->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(164);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and group members on the same IP have earned access to The Deep.") if $flagged;
	} elsif ($raid) {
		for (my $i = 0; $i < $raid->RaidCount(); $i++) {
			my $member = $raid->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(164);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and raid members on the same IP have earned access to The Deep.") if $flagged;
	} else {
		$client->SetZoneFlag(164);
		quest::we(14, "$name has earned access to The Deep.");
	}

	# Check if the item exists and remove it
	if (quest::countitem(40394) >= 1) {
		quest::removeitem(40394, 1);
	}
}