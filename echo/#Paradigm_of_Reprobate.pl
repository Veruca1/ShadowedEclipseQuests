sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $flag_key = "echo.mainboss.$char_id";
    my $lock_key = "-echobossfight_lockout";

    my $new_npc_id = 1927;
    my $new_npc_x = $x;
    my $new_npc_y = $y;
    my $new_npc_z = $z;
    my $new_npc_h = $h;

    my $echo_link = quest::saylink("Echo Boss", 1);  # Creates a clickable link

    if ($text =~ /hail/i) {
        if (quest::get_data($flag_key)) {
            plugin::Whisper("You have already turned in the heads. Say $echo_link when you are ready to face your challenge.");
        } else {
            plugin::Whisper("Bring me the 4 unique heads, and I will allow you to challenge the Echo Boss.");
        }
    }

    if ($text =~ /echo boss/i) {
        if (quest::get_data($flag_key)) {
            if (!$client->GetBucket($lock_key)) {
                $client->SetBucket($lock_key, 1, 600);  # 10-minute cooldown
                quest::depop();  # Depop self (1926)
                quest::spawn2($new_npc_id, 0, 0, $new_npc_x, $new_npc_y, $new_npc_z, $new_npc_h);  # Spawn the boss
            } else {
                my $remaining = quest::secondstotime($client->GetBucketRemaining($lock_key));
                quest::message(315, "You must wait [$remaining] to challenge the Echo Boss again.");
            }
        } else {
            plugin::Whisper("You have not turned in the required items.");
        }
    }
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();
    my $flag_key = "echo.mainboss.$char_id";

    if (plugin::check_handin(\%itemcount, 40388 => 1, 40389 => 1, 40390 => 1, 40391 => 1)) {
        quest::set_data($flag_key, 1);
        plugin::Whisper("The ritual is complete. You are now flagged to challenge the Echo Boss. Say 'Echo Boss' when ready.");
    } else {
        plugin::return_items(\%itemcount);
        plugin::Whisper("I need all 4 unique heads to proceed.");
    }
}