sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Offer the task/quest when hailed
        my $task_id = 14;  # Task ID for Dalnir access
        $client->Message(14, "Greetings, adventurer. The depths of Dalnir are not for the faint of heart. If you wish to gain access, you must prove yourself worthy. There are matters to tend to out in these woods. Once you have done that, I shall grant you access.");
        quest::assigntask($task_id);  # Assign task ID 14
    }
}

sub EVENT_ITEM {
    # Define the item IDs
    my $completion_item = 32459; # Item for Dalnir access
    my $letter_to_overthere = 32470; # Written letter to Overthere

    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();
    my $flagged = 0;

    # Check if the player handed in the task completion item for Dalnir access
    if (plugin::check_handin(\%itemcount, $completion_item => 1)) {
        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(104);
                    $member->Message(15, "You now have access to The Crypt of Dalnir. Proceed with caution, adventurer.");
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and group members on the same IP have earned access to The Crypt of Dalnir!");
            }
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(104);
                    $member->Message(15, "You now have access to The Crypt of Dalnir. Proceed with caution, adventurer.");
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and raid members on the same IP have earned access to The Crypt of Dalnir!");
            }
        } else {
            $client->SetZoneFlag(104);
            $client->Message(15, "You now have access to The Crypt of Dalnir. Proceed with caution, adventurer.");
            quest::we(14, "$name has earned access to The Crypt of Dalnir!");
        }

        # Optionally, provide experience points or additional rewards
        quest::exp(1000);
    }
    # Check if the player handed in the letter to Overthere
    elsif (plugin::check_handin(\%itemcount, $letter_to_overthere => 1)) {
        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(93);
                    $member->Message(14, "I see you have found the letter. Time seems to have lost all meaning in that strange place. You should seek out Neriah Dawnbinder in The Overthere, outside the outpost. She can help guide you further.");
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and group members on the same IP have earned access to The Overthere!");
            }
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(93);
                    $member->Message(14, "I see you have found the letter. Time seems to have lost all meaning in that strange place. You should seek out Neriah Dawnbinder in The Overthere, outside the outpost. She can help guide you further.");
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and raid members on the same IP have earned access to The Overthere!");
            }
        } else {
            $client->SetZoneFlag(93);
            $client->Message(14, "I see you have found the letter. Time seems to have lost all meaning in that strange place. You should seek out Neriah Dawnbinder in The Overthere, outside the outpost. She can help guide you further.");
            quest::we(14, "$name has earned access to The Overthere!");
        }
    } else {
        plugin::return_items(\%itemcount);
    }
}