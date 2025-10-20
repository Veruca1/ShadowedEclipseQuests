sub EVENT_ITEM_CLICK {
    my $key_item = 60468;       # Arcstone key item ID
    my $zone_id  = 369;         # Arcstone zone ID
    my $zone_name = "Arcstone, Isle of Spirits";

    # Only proceed if the clicked item matches
    return unless $itemid == $key_item;

    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid  = $client->GetRaid();
    my $flagged = 0;

    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag($zone_id);
                $flagged = 1;
            }
        }
        if ($flagged) {
            quest::we(14, "$name and group members on the same IP have earned access to $zone_name.");
        }
    } elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag($zone_id);
                $flagged = 1;
            }
        }
        if ($flagged) {
            quest::we(14, "$name and raid members on the same IP have earned access to $zone_name.");
        }
    } else {
        $client->SetZoneFlag($zone_id);
        quest::we(14, "$name has earned access to $zone_name.");
    }

    # Remove the Arcstone key item
    if (quest::countitem($key_item) >= 1) {
        quest::removeitem($key_item, 1);
    }
}