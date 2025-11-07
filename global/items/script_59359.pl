sub EVENT_ITEM_CLICK {
    quest::debug("EVENT_ITEM_CLICK fired for $name with item ID $itemid");
    return unless $itemid == 59359;
    quest::debug("Correct item ($itemid) clicked by $name.");
    
    my @zone_flags = (
        # Antonica
        18, 39, 59, 64, 66, 71, 72, 74, 101, 407, 32, 73, 96, 91, 11, 17, 40, 41, 42,
        # Kunark
        97, 88, 92, 81, 107, 79, 104, 93, 105, 94, 90, 85, 87, 109, 84, 102, 95, 89, 103, 108,
        # Velious
        110, 111, 116, 121, 118, 112, 117, 125, 120, 123, 119, 113, 127, 128, 124,
        # Luclin
        459, 165, 156, 153, 164, 173, 179, 172, 160, 170, 157, 167, 175, 169, 171, 162
    );
    
    my $ip    = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid  = $client->GetRaid();
    quest::debug("Client IP: $ip | Group: " . ($group ? "Yes" : "No") . " | Raid: " . ($raid ? "Yes" : "No"));
    
    my @eligible_members;
    
    if ($group) {
        quest::debug("Processing group...");
        for (my $i = 0; $i < $group->GroupCount(); $i++) {
            my $member = $group->GetMember($i);
            next unless $member;
            if ($member->GetIP() eq $ip) {
                push @eligible_members, $member;
                quest::debug("Group member " . $member->GetName() . " added.");
            }
        }
        quest::we(15, "$name and group members on the same IP have been flagged through Luclin.");
    }
    elsif ($raid) {
        quest::debug("Processing raid...");
        for (my $i = 0; $i < $raid->RaidCount(); $i++) {
            my $member = $raid->GetMember($i);
            next unless $member;
            if ($member->GetIP() eq $ip) {
                push @eligible_members, $member;
                quest::debug("Raid member " . $member->GetName() . " added.");
            }
        }
        quest::we(15, "$name and raid members on the same IP have been flagged through Luclin.");
    }
    else {
        quest::debug("No group or raid. Adding client directly.");
        push @eligible_members, $client;
        quest::we(15, "$name has been flagged through Luclin.");
    }
    
    foreach my $member (@eligible_members) {
        quest::debug("Flagging " . $member->GetName());
        foreach my $zone_id (@zone_flags) {
            eval {
                $member->SetZoneFlag($zone_id);
            };
            if ($@) {
                quest::debug("Error setting flag $zone_id for " . $member->GetName() . ": $@");
            }
        }
        $member->Message(15, "You have received access to all major zones through Luclin. Thank you for your support!");
    }
    
    $client->RemoveItem($itemid);
    quest::debug("Item $itemid removed from $name's inventory.");
}