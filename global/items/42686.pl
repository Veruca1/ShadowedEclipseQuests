sub EVENT_ITEM_CLICK {
	# Ensure this item can only be clicked in The Twilight Sea (zone ID 170)
	if ($zoneid != 170) {
		$client->Message(315, "You sense this artifact will only function within the waves of The Twilight Sea.");
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
				$member->SetZoneFlag(157);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and group members on the same IP have earned access to The Fungus Grove!") if $flagged;
	} elsif ($raid) {
		for (my $i = 0; $i < $raid->RaidCount(); $i++) {
			my $member = $raid->GetMember($i);
			next unless $member;
			if ($member->GetIP() == $clicker_ip) {
				$member->SetZoneFlag(157);
				$flagged = 1;
			}
		}
		quest::we(14, "$name and raid members on the same IP have earned access to The Fungus Grove!") if $flagged;
	} else {
		$client->SetZoneFlag(157);
		quest::we(14, "$name has earned access to The Fungus Grove!");
	}

	$client->Message(315, "The artifact pulses with fungal spores before crumbling to dust.");

	# Always remove one item (42686)
	quest::removeitem(42686, 1);
}