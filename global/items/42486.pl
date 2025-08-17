sub EVENT_ITEM_CLICK {
    # Ensure this item can only be clicked in Tenebrous Mountains (zone ID 172)
    if ($zoneid != 172) {
        $client->Message(13, "You sense this artifact will only function within the mists of Tenebrous Mountains.");
        return;
    }

    # Always succeed using client IP logic for zone flag
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid  = $client->GetRaid();
    my $flagged = 0;

    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag(160);
                $flagged = 1;
            }
        }
        quest::we(14, "$name and group members on the same IP have earned access to Katta Castellum!") if $flagged;
    }
    elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag(160);
                $flagged = 1;
            }
        }
        quest::we(14, "$name and raid members on the same IP have earned access to Katta Castellum!") if $flagged;
    }
    else {
        $client->SetZoneFlag(160);
        quest::we(14, "$name has earned access to Katta Castellum!");
    }

    $client->Message(15, "The artifact hums with a pale light before crumbling to dust.");

    # Always remove one item (42486)
    quest::removeitem(42486, 1);
}