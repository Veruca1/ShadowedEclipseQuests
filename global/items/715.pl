sub EVENT_ITEM_CLICK {
    # Check if the player has the key (item ID 715)
    if (quest::countitem(715) >= 1) {
        my $clicker_ip = $client->GetIP();
        my $group = $client->GetGroup();
        my $raid = $client->GetRaid();
        my $flagged = 0;

        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(11);
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and group members on the same IP have earned access to Runnyeye.");
            }
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(11);
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and raid members on the same IP have earned access to Runnyeye.");
            }
        } else {
            $client->SetZoneFlag(11);
            quest::we(14, "$name has earned access to Runnyeye.");
        }

        # Remove the key item from the player's inventory
        quest::removeitem(715, 1);
    }
}