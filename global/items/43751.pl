sub EVENT_ITEM_CLICK {
	# Ensure this item can only be clicked in Katta Castellum (zone ID 160)
	if ($zoneid != 160) {
		$client->Message(315, "You sense this artifact will only function within the walls of Katta Castellum.");
		return;
	}

	# Always succeed using client IP logic for zone flag
	my $clicker_ip = $client->GetIP();
	my $group = $client->GetGroup();
	my $raid  = $client->GetRaid();
	my $flagged = 0;

	if ($group) {
		for (my $i = 0; $i < $group->GroupCount(); $i++) {
			my $member = $group->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(170);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and group members on the same IP have earned access to The Twilight Sea!") if $flagged;
	} elsif ($raid) {
		for (my $i = 0; $i < $raid->RaidCount(); $i++) {
			my $member = $raid->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(170);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and raid members on the same IP have earned access to The Twilight Sea!") if $flagged;
	} else {
		$client->SetZoneFlag(170);
		quest::we(14, "$name has earned access to The Twilight Sea!");
	}

	$client->Message(315, "The artifact shimmers with dusky light before crumbling to dust.");

	# Always remove one item (43751)
	quest::removeitem(43751, 1);
}