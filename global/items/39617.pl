sub EVENT_ITEM_CLICK {
    my $char_id = $client->CharacterID();
    my $flag_key = "${char_id}_void_flag";  # Unique key to prevent re-flagging
    my $cooldown_check = $client->GetBucket("voida_click_cd");
    my $clicker_ip = $client->GetIP();
    my $group = $client->GetGroup();
    my $raid = $client->GetRaid();
    my $flagged = 0;
    my $announce = 0;

    if (!$cooldown_check) {
        # First-time flagging
        if (!quest::get_data($flag_key)) {
            if ($group) {
                for (my $i = 0; $i < $group->GroupCount(); $i++) {
                    my $member = $group->GetMember($i);
                    next unless $member;
                    if ($member->GetIP() == $clicker_ip) {
                        $member->SetZoneFlag(459);
                        $member->MovePC(459, 0, 0, 0, 0);
                        $flagged = 1;
                    }
                }
                $announce = 1 if $flagged;
            } elsif ($raid) {
                for (my $i = 0; $i < $raid->RaidCount(); $i++) {
                    my $member = $raid->GetMember($i);
                    next unless $member;
                    if ($member->GetIP() == $clicker_ip) {
                        $member->SetZoneFlag(459);
                        $member->MovePC(459, 0, 0, 0, 0);
                        $flagged = 1;
                    }
                }
                $announce = 1 if $flagged;
            } else {
                $client->SetZoneFlag(459);
                $client->MovePC(459, 0, 0, 0, 0);
                $announce = 1;
            }

            quest::set_data($flag_key, 1);  # Prevent future announcements
            quest::we(14, "$name and their companions have gained access to The Void!") if $announce;
        } else {
            # Already flagged - just move
            $client->MovePC(459, 0, 0, 0, 0);
        }

        $client->SetBucket("voida_click_cd", 1, 60);  # 60-second cooldown
    } else {
        my $remaining_time = quest::secondstotime($client->GetBucketRemaining("voida_click_cd"));
        quest::message(315, "The shard hums, but remains inert. Wait $remaining_time before using it again.");
    }
}