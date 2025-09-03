sub EVENT_ITEM_CLICK {
	# Only allow use in Shadeweaver's Thicket (zone ID 165)
	if ($zoneid != 165) {
		$client->Message(315, "Nothing happens.");
		return;
	}

	# Grant Paludal Caverns zone flag (zone ID 156) using client IP logic
	my $clicker_ip = $client->GetIP();
	my $group = $client->GetGroup();
	my $raid  = $client->GetRaid();
	my $flagged = 0;

	if ($group) {
		for (my $i = 0; $i < $group->GroupCount(); $i++) {
			my $member = $group->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(156);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and group members on the same IP have earned access to The Paludal Caverns.") if $flagged;
	}
	elsif ($raid) {
		for (my $i = 0; $i < $raid->RaidCount(); $i++) {
			my $member = $raid->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(156);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and raid members on the same IP have earned access to The Paludal Caverns.") if $flagged;
	}
	else {
		$client->SetZoneFlag(156);
		quest::we(14, "$name has earned access to The Paludal Caverns.");
	}

	# Remove the item if it exists
	if (quest::countitem(33211) >= 1) {
		quest::removeitem(33211, 1);
	}
}