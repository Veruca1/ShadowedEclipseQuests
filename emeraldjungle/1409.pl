sub EVENT_SAY {
    if ($text=~/hail/i) {
        my $task_id = 17;  # Task ID for City of Mist Access
        $client->Message(14, "Greetings, adventurer. There is a disturbance in The City of Mist, formerly known as Torsis. To gain access to the city, I need you to run a few errands for me.");
        quest::assigntask($task_id);  # Assign task ID 17
    }
}

sub EVENT_ITEM {
    my $item_id_33027 = 33027;
    my $stack_size = 30;
    my $item_id_access_90 = 33120;  # Item ID for City of Mist access
    my $item_id_access_85 = 33030;  # Item ID for Lake of Ill Omen access
    my $task_id_18 = 18;

    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();
    my $flagged = 0;

    if (plugin::check_handin(\%itemcount, $item_id_33027 => $stack_size)) {
        quest::say("Very well, good luck!");
        quest::spawn2(1392, 0, 0, 286.18, 1245.05, -338.84, 264.25);
    }

    elsif (plugin::check_handin(\%itemcount, $item_id_access_90 => 1)) {
        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(90);
                    $member->Message(14, "You now have access to the City of Mist. Proceed with caution.");
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and group members on the same IP have earned access to the City of Mist!");
            }
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(90);
                    $member->Message(14, "You now have access to the City of Mist. Proceed with caution.");
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and raid members on the same IP have earned access to the City of Mist!");
            }
        } else {
            $client->SetZoneFlag(90);
            $client->Message(14, "You now have access to the City of Mist. Proceed with caution.");
            quest::we(14, "$name has earned access to the City of Mist!");
        }

        quest::say("Additionally, I have another task for you.");
        quest::assigntask($task_id_18);
    }

    elsif (plugin::check_handin(\%itemcount, $item_id_access_85 => 1)) {
        $flagged = 0;

        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->Message(14, "Outstanding! You have undone Zarrin's work in Torsis and saved Zal`Ashiir. Amazing work adventurer. However, you are needed at once at the Lake of Ill Omen. Meet up with Syrik Iceblood at the lake's western shore.");
                    $member->SetZoneFlag(85);
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and group members on the same IP have earned access to the Lake of Ill Omen!");
            }
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->Message(14, "Outstanding! You have undone Zarrin's work in Torsis and saved Zal`Ashiir. Amazing work adventurer. However, you are needed at once at the Lake of Ill Omen. Meet up with Syrik Iceblood at the lake's western shore.");
                    $member->SetZoneFlag(85);
                    $flagged = 1;
                }
            }
            if ($flagged) {
                quest::we(14, "$name and raid members on the same IP have earned access to the Lake of Ill Omen!");
            }
        } else {
            $client->SetZoneFlag(85);
            $client->Message(14, "Outstanding! You have undone Zarrin's work in Torsis and saved Zal`Ashiir. Amazing work adventurer. However, you are needed at once at the Lake of Ill Omen. Meet up with Syrik Iceblood at the lake's western shore.");
            quest::we(14, "$name has earned access to the Lake of Ill Omen!");
        }
    }

    else {
        plugin::return_items(\%itemcount);
    }
}