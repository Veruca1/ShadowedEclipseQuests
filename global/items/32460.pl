sub EVENT_ITEM_CLICK {
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();

    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;

            if ($member->GetIP() == $clicker_ip) {
                $member->Message(15, "You have earned access to The Howling Stones.");
                $member->SetZoneFlag(105);
            }
        }

        quest::we(14, "$name and group members on the same IP have earned access to The Howling Stones.");
    } else {
        # Solo player
        $client->SetZoneFlag(105);
        quest::we(14, "$name has earned access to The Howling Stones.");
    }

    # Remove the item if it exists
    if (quest::countitem(32460) >= 1) {
        quest::removeitem(32460, 1);
    }
}