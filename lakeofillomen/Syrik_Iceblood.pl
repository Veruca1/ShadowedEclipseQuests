sub EVENT_ITEM {
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();
    my $flagged = 0;

    # Check if the player hands in the correct item (Item ID 33033)
    if (plugin::check_handin(\%itemcount, 33033 => 1)) {

        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;

                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(109);
                    $member->Message(15, "You now have access to Veksar. Be very careful and avoid ending up like the other lost souls there.");
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and group members on the same IP have earned access to Veksar!");
            }
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;

                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(109);
                    $member->Message(15, "You now have access to Veksar. Be very careful and avoid ending up like the other lost souls there.");
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and raid members on the same IP have earned access to Veksar!");
            }
        } else {
            $client->SetZoneFlag(109);
            $client->Message(15, "You now have access to Veksar. Be very careful and avoid ending up like the other lost souls there.");
            quest::we(14, "$name has earned access to Veksar!");
        }

        quest::assigntask(20); # Assign next task
    } else {
        quest::say("I have no need for these items, $name.");
        plugin::return_items(\%itemcount);
        return;
    }
}

sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::say("Greetings, $name. If you seek access to Veksar, you must first prove your worth.");
        quest::assigntask(19); # Assign initial task
    }
}