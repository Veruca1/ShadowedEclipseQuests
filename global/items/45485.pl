sub EVENT_ITEM_CLICK {
    # Only functions in The Fungus Grove (zone ID 157)
    if ($zoneid != 157) {
        $client->Message(13, "This key remains dormant outside the depths of the Fungus Grove.");
        return;
    }

    # Grant access to Grimling Forest (zone ID 167) using client IP logic
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid  = $client->GetRaid();
    my $flagged = 0;

    if ($group) {
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag(167);
                $flagged = 1;
            }
        }
        quest::we(14, "$name and group members on the same IP have attuned to the shadows of Grimling Forest.") if $flagged;
    }
    elsif ($raid) {
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;
            if ($member->GetIP() == $clicker_ip) {
                $member->SetZoneFlag(167);
                $flagged = 1;
            }
        }
        quest::we(14, "$name and raid members on the same IP have attuned to the shadows of Grimling Forest.") if $flagged;
    }
    else {
        $client->SetZoneFlag(167);
        quest::we(14, "$name has attuned to the shadows of Grimling Forest.");
    }

    $client->Message(15, "The key trembles softly... and crumbles in your grasp.");

    # Remove one copy of the key item (45485)
    quest::removeitem(45485, 1);
}