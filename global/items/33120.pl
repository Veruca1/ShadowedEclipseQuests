sub EVENT_ITEM_CLICK {
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();
    my $gave_flag = 0;

    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;

            if ($member->GetIP() == $clicker_ip) {
                $member->Message(15, "You have earned access to the City of Mist (Torsis).");
                $member->SetZoneFlag(90);
                $gave_flag = 1;
            }
        }

        if ($gave_flag) {
            quest::we(14, "$name and group members on the same IP have earned access to the City of Mist (Torsis).");
        }
    } elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;

            if ($member->GetIP() == $clicker_ip) {
                $member->Message(15, "You have earned access to the City of Mist (Torsis).");
                $member->SetZoneFlag(90);
                $gave_flag = 1;
            }
        }

        if ($gave_flag) {
            quest::we(14, "$name and raid members on the same IP have earned access to the City of Mist (Torsis).");
        }
    } else {
        $client->SetZoneFlag(90);
        quest::we(14, "$name has earned access to the City of Mist (Torsis).");
    }

    # Remove the item if it exists
    if (quest::countitem(33120) >= 1) {
        quest::removeitem(33120, 1);
    }
}