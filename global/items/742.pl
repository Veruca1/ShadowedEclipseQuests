sub EVENT_ITEM_CLICK {
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();
    my $flagged = 0;

    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag(120);
                $flagged = 1;
            }
        }
        if ($flagged) {
            quest::we(14, "$name and group members on the same IP have earned access to The Western Wastes.");
        }
    } elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag(120);
                $flagged = 1;
            }
        }
        if ($flagged) {
            quest::we(14, "$name and raid members on the same IP have earned access to The Western Wastes.");
        }
    } else {
        $client->SetZoneFlag(120);
        quest::we(14, "$name has earned access to The Western Wastes.");
    }

    # Check if the item exists and remove it
    if (quest::countitem(742) >= 1) {
        quest::removeitem(742, 1);
    }
}