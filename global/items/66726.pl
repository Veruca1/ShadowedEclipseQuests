sub EVENT_ITEM_CLICK {
    my $clicker_ip = $client->GetIP();
    my $group      = $client->GetGroup();
    my $raid       = $client->GetRaid();
    my $flagged    = 0;
    my $zone_flag  = 221;     # Lair of Terris Thule
    my $item_id    = 66726;   # Key item ID

    # === Group Handling ===
    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag($zone_flag);
                $flagged = 1;
            }
        }
        if ($flagged) {
            quest::we(14, "$name and their group members on the same IP have gained access to The Lair of Terris Thule!");
        }

    # === Raid Handling ===
    } elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag($zone_flag);
                $flagged = 1;
            }
        }
        if ($flagged) {
            quest::we(14, "$name and their raid members on the same IP have gained access to The Lair of Terris Thule!");
        }

    # === Solo Handling ===
    } else {
        $client->SetZoneFlag($zone_flag);
        quest::we(14, "$name has gained access to The Lair of Terris Thule!");
    }

    # === Remove the item after successful click ===
    if ($client->HasItem($item_id)) {
        $client->RemoveItem($item_id, 1);
    }
}