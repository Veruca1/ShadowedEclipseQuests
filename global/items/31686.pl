sub EVENT_ITEM_CLICK {
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();
    my %flagged_ids;
    my $flagged = 0;

    # Group members
    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;
            my $cid = $member->CharacterID();

            if ($member->GetIP() == $clicker_ip && !$flagged_ids{$cid}) {
                $member->Message(15, "You have earned access to Kurn's Tower (No EXP Zone).");
                $member->SetZoneFlag(97);
                $flagged_ids{$cid} = 1;
                $flagged = 1;
            }
        }
    }

    # Raid members
    if ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;
            my $cid = $member->CharacterID();

            if ($member->GetIP() == $clicker_ip && !$flagged_ids{$cid}) {
                $member->Message(15, "You have earned access to Kurn's Tower (No EXP Zone).");
                $member->SetZoneFlag(97);
                $flagged_ids{$cid} = 1;
                $flagged = 1;
            }
        }
    }

    # Solo player fallback
    if (!$group && !$raid) {
        $client->SetZoneFlag(97);
        quest::we(14, "$name has earned access to Kurn's Tower (No EXP Zone).");
    } elsif ($flagged) {
        quest::we(14, "$name and group/raid members on the same IP have earned access to Kurn's Tower (No EXP Zone).");
    }

    # Remove the item if it exists
    if (quest::countitem(31686) >= 1) {
        quest::removeitem(31686, 1);
    }
}