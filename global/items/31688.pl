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
                $member->Message(15, "You have earned access to Kaesora.");
                $member->SetZoneFlag(88);
                $flagged = 1;
            }
        }

        if ($flagged) {
            quest::we(14, "$name and group members on the same IP have earned access to Kaesora.");
        }
    } elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;

            if ($member->GetIP() == $clicker_ip) {
                $member->Message(15, "You have earned access to Kaesora.");
                $member->SetZoneFlag(88);
                $flagged = 1;
            }
        }

        if ($flagged) {
            quest::we(14, "$name and raid members on the same IP have earned access to Kaesora.");
        }
    } else {
        # Solo player
        $client->SetZoneFlag(88);
        quest::we(14, "$name has earned access to Kaesora.");
    }

    # Remove the item if it exists
    if (quest::countitem(31688) >= 1) {
        quest::removeitem(31688, 1);
    }
}