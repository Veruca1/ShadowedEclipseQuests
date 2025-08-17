sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Offer the task/quest when hailed
        my $task_id = 21;  # Task ID for Karnor's Castle access
        $client->Message(14, "Greetings, adventurer. Karnor's Castle is a place of danger and mystery. Before you can enter its gates, you must first prove your worth. There are challenges to overcome in the wilds. Return when you are ready, and I shall grant you access.");
        quest::assigntask($task_id);  # Assign task ID 21.
    }
}

sub EVENT_ITEM {
    my $key_to_karnors = 255;  # Key to Karnor's Castle
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();
    my $flagged = 0;

    if (plugin::check_handin(\%itemcount, $key_to_karnors => 1)) {
        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(102);
                    $member->Message(15, "You now have access to Karnor's Castle. Tread carefully, adventurer. There are rumors of that place not being what is expected. It's like, it's gone back in time, yet not at the same time. Also, Venril Sathir is nowhere to be found there!");
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and group members on the same IP have earned access to Karnor's Castle!");
            }
        }
        elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(102);
                    $member->Message(15, "You now have access to Karnor's Castle. Tread carefully, adventurer. There are rumors of that place not being what is expected. It's like, it's gone back in time, yet not at the same time. Also, Venril Sathir is nowhere to be found there!");
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and raid members on the same IP have earned access to Karnor's Castle!");
            }
        }
        else {
            $client->SetZoneFlag(102);
            $client->Message(15, "You now have access to Karnor's Castle. Tread carefully, adventurer. There are rumors of that place not being what is expected. It's like, it's gone back in time, yet not at the same time. Also, Venril Sathir is nowhere to be found there!");
            quest::we(14, "$name has earned access to Karnor's Castle!");
        }
    }
    else {
        plugin::return_items(\%itemcount);
    }
}