sub EVENT_ITEM_CLICK {    
	# Grant The Echo Caverns zone flag (zone ID 153) using client IP logic
	my $clicker_ip = $client->GetIP();
	my $group = $client->GetGroup();
	my $raid  = $client->GetRaid();
	my $flagged = 0;

	if ($group) {
		for (my $i = 0; $i < $group->GroupCount(); $i++) {
			my $member = $group->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(153);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and group members on the same IP have earned access to The Echo Caverns.") if $flagged;
	} elsif ($raid) {
		for (my $i = 0; $i < $raid->RaidCount(); $i++) {
			my $member = $raid->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(153);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and raid members on the same IP have earned access to The Echo Caverns.") if $flagged;
	} else {
		$client->SetZoneFlag(153);
		quest::we(14, "$name has earned access to The Echo Caverns.");
	}

	# Check if the item exists and remove it
	if (quest::countitem(40393) >= 1) {
		quest::removeitem(40393, 1);
	}
}