sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::assigntask(29);
        my $saylink = quest::saylink("to go", 1); # Create clickable saylink
        quest::whisper("Ahoy, matey! Welcome to Iceclad! The only way to find yer bearin's 'ere is to explore the frozen wastes. I can lend ye a hand, but ye'll need to help me out too. Take care o' some o' the beasties lurkin' about, and ye'll see the tide turn in yer favor. Trust in ol' Masurt aye? If ye wish, I can send ye [$saylink] to the Great Divide.");
    }
    elsif ($text=~/to go/i) {
        quest::movepc(118, 701.03, -1085.54, 29.49, 113); # Move player to The Great Divide
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 539 => 1)) { # The Great Divide
        my $clicker_ip = $client->GetIP();
        my $group = $client->GetGroup();
        my $raid = $client->GetRaid();

        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(118);
                }
            }
            quest::we(14, "$name and group members on the same IP have earned access to The Great Divide!");
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(118);
                }
            }
            quest::we(14, "$name and raid members on the same IP have earned access to The Great Divide!");
        } else {
            $client->SetZoneFlag(118);
            quest::we(14, "$name has earned access to The Great Divide!");
        }
        my $saylink = quest::saylink("to go", 1);
        quest::whisper("Arr, ye now 'ave access to The Great Divide! Seek out an old friend there; they'll guide ye further on this journey. Would ye like to [$saylink] there now?");
    }
    elsif (plugin::check_handin(\%itemcount, 512 => 1)) { # Tower of Frozen Shadows
        my $clicker_ip = $client->GetIP();
        my $group = $client->GetGroup();
        my $raid = $client->GetRaid();

        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(111);
                }
            }
            quest::we(14, "$name and group members on the same IP have earned access to The Tower of Frozen Shadows!");
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(111);
                }
            }
            quest::we(14, "$name and raid members on the same IP have earned access to The Tower of Frozen Shadows!");
        } else {
            $client->SetZoneFlag(111);
            quest::we(14, "$name has earned access to The Tower of Frozen Shadows!");
        }
        quest::whisper("Well, ye now 'ave access to that terrible tower. Not sure why ye'd want to go in there...");
    }
    elsif (plugin::check_handin(\%itemcount, 528 => 1)) { # Crystal Caverns
        my $clicker_ip = $client->GetIP();
        my $group = $client->GetGroup();
        my $raid = $client->GetRaid();

        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(121);
                }
            }
            quest::we(14, "$name and group members on the same IP have earned access to The Crystal Caverns!");
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(121);
                }
            }
            quest::we(14, "$name and raid members on the same IP have earned access to The Crystal Caverns!");
        } else {
            $client->SetZoneFlag(121);
            quest::we(14, "$name has earned access to The Crystal Caverns!");
        }
        quest::whisper("Congratulations, adventurer! The Crystal Caverns await ye...");
    }
    elsif (plugin::check_handin(\%itemcount, 518 => 1)) { # Eastern Wastes
        my $clicker_ip = $client->GetIP();
        my $group = $client->GetGroup();
        my $raid = $client->GetRaid();

        if ($group) {
            for (my $i = 0; $i < $group->GroupCount(); $i++) {
                my $member = $group->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(116);
                }
            }
            quest::we(14, "$name and group members on the same IP have earned access to The Eastern Wastes!");
        } elsif ($raid) {
            for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                my $member = $raid->GetMember($i);
                next unless $member;
                if ($member->GetIP() == $clicker_ip) {
                    $member->SetZoneFlag(116);
                }
            }
            quest::we(14, "$name and raid members on the same IP have earned access to The Eastern Wastes!");
        } else {
            $client->SetZoneFlag(116);
            quest::we(14, "$name has earned access to The Eastern Wastes!");
        }
        quest::whisper("Ye've earned yer passage to the Eastern Wastes...");
    }
    elsif (plugin::check_handin(\%itemcount, 60333 => 1)) {
        quest::whisper("Thank ye kindly for this, matey! I'll put it to good use.");
    }
    else {
        plugin::return_items(\%itemcount);
    }
}