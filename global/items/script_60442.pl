sub EVENT_ITEM_CLICK {
    my $backflag_item = 60442; # Lesser Seal of Expedience
    return unless $itemid == $backflag_item;

    my @zone_flags = (
        # Antonica
        18, 39, 59, 64, 66, 71, 72, 74, 101, 407, 32, 73, 96, 91, 11, 17, 40, 41, 42,
        # Kunark
        97, 88, 92, 81, 107, 79, 104, 93, 105, 94, 90, 85, 87, 109, 84, 102, 95, 89, 103, 108
    );

    my $ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid  = $client->GetRaid();

    my @eligible_members;

    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;
            push @eligible_members, $member if $member->GetIP() eq $ip;
        }
        quest::we(15, "$name and group members on the same IP have been flagged through Kunark.");
    }
    elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;
            push @eligible_members, $member if $member->GetIP() eq $ip;
        }
        quest::we(15, "$name and raid members on the same IP have been flagged through Kunark.");
    }
    else {
        push @eligible_members, $client;
        quest::we(15, "$name has been flagged through Kunark.");
    }

    foreach my $member (@eligible_members) {
        foreach my $zone_id (@zone_flags) {
            $member->SetZoneFlag($zone_id);
        }
        $member->Message(15, "You have received access to all major zones through Kunark. Thank you for your support!");
    }

    $client->RemoveItem($itemid); # One-and-done
}