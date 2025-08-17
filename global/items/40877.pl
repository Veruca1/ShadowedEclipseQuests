sub EVENT_ITEM_CLICK {
    # Ensure this item can only be clicked in Akheva Ruins (zone ID 179)
    if ($zoneid != 179) {
        $client->Message(13, "You sense this artifact will only function within the shadows of Akheva Ruins.");
        return;
    }

    # Always succeed - Set the zone flag for Tenebrous Mountains (zone ID 172) using client IP logic
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid  = $client->GetRaid();
    my $flagged = 0;

    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag(172);
                $flagged = 1;
            }
        }
        quest::we(14, "$name and group members on the same IP have earned access to Tenebrous Mountains!") if $flagged;
    }
    elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag(172);
                $flagged = 1;
            }
        }
        quest::we(14, "$name and raid members on the same IP have earned access to Tenebrous Mountains!") if $flagged;
    }
    else {
        $client->SetZoneFlag(172);
        quest::we(14, "$name has earned access to Tenebrous Mountains!");
    }

    $client->Message(15, "The artifact glows with umbral energy before crumbling to dust.");

    # Always remove one item (40877)
    quest::removeitem(40877, 1);
}