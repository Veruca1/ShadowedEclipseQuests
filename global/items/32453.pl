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
                $member->Message(15, "You have earned access to The Mines of Nurga.");
                $member->SetZoneFlag(107);
                $flagged = 1;
            }
        }

        if ($flagged) {
            quest::we(14, "$name and group members on the same IP have earned access to The Mines of Nurga.");
        }
    } elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;

            if ($member->GetIP() == $clicker_ip) {
                $member->Message(15, "You have earned access to The Mines of Nurga.");
                $member->SetZoneFlag(107);
                $flagged = 1;
            }
        }

        if ($flagged) {
            quest::we(14, "$name and raid members on the same IP have earned access to The Mines of Nurga.");
        }
    } else {
        $client->SetZoneFlag(107);
        $client->Message(15, "You have earned access to The Mines of Nurga.");
        quest::we(14, "$name has earned access to The Mines of Nurga.");
    }

    if (quest::countitem(32453) >= 1) {
        quest::removeitem(32453, 1);
    }
}