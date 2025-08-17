sub EVENT_ITEM_CLICK {
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();

    if ($itemid == 402) {
        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(32);   # soldungb
                    $member->SetZoneFlag(73);   # permafrost
                    $member->SetZoneFlag(96);   # timorous
                    $member->SetZoneFlag(91);   # skyfire
                    $member->Message(14, "You have been granted access to several key locations.");
                }
            }
            quest::we(14, "$name and group members on the same IP have received new zone access!");
        }
        elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(32);   # soldungb
                    $member->SetZoneFlag(73);   # permafrost
                    $member->SetZoneFlag(96);   # timorous
                    $member->SetZoneFlag(91);   # skyfire
                    $member->Message(14, "You have been granted access to several key locations.");
                }
            }
            quest::we(14, "$name and raid members on the same IP have received new zone access!");
        } else {
            $client->SetZoneFlag(32);   # soldungb
            $client->SetZoneFlag(73);   # permafrost
            $client->SetZoneFlag(96);   # timorous
            $client->SetZoneFlag(91);   # skyfire
            $client->Message(14, "You have been granted access to several key locations.");
            quest::we(14, "$name has received new zone access!");
        }

        quest::assigntask(28);        # Assign task
        quest::removeitem(402);       # Remove item
    }
}