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
                $member->Message(15, "You have earned access to The Temple of Droga.");
                $member->SetZoneFlag(81);
                $flagged = 1;
            }
        }

        if ($flagged) {
            quest::we(14, "$name and group members on the same IP have earned access to The Temple of Droga.");
        }
    } elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;

            if ($member->GetIP() == $clicker_ip) {
                $member->Message(15, "You have earned access to The Temple of Droga.");
                $member->SetZoneFlag(81);
                $flagged = 1;
            }
        }

        if ($flagged) {
            quest::we(14, "$name and raid members on the same IP have earned access to The Temple of Droga.");
        }
    } else {
        $client->SetZoneFlag(81);
        $client->Message(15, "You have earned access to The Temple of Droga.");
        quest::we(14, "$name has earned access to The Temple of Droga.");
    }

    if (quest::countitem(32344) >= 1) {
        quest::removeitem(32344, 1);
    }
}