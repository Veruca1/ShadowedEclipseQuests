sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "${char_id}_veeshan_secret_boss_flag";  # Unique flag for this player

    if (plugin::check_handin(\%itemcount, 433 => 1)) {
        # Set the flag indicating the player is flagged
        quest::set_data($flag, 1);
        
        $client->Message(15, "YOU BETTER GET BACK!!!...");

        # Start a 10-second timer for NPC spawn
        quest::settimer("spawn_npc", 10);
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc") {
        quest::stoptimer("spawn_npc");

        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        quest::spawn2(1585, 0, 0, $x, $y, $z, $h);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $flag = "${char_id}_veeshan_secret_boss_flag";
    my $cooldown_key = "${char_id}_veeshan_hail_cd";
    my $cooldown_time = 60;  # 1 minutes
    my $current_time = time();

    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            my $last_hail_time = quest::get_data($cooldown_key);

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                quest::set_data($cooldown_key, $current_time);

                # Message and spawn the boss
                $client->Message(15, "YOU BETTER GET BACK!!!...");

                my $x = $npc->GetX();
                my $y = $npc->GetY();
                my $z = $npc->GetZ();
                my $h = $npc->GetHeading();

                quest::spawn2(1585, 0, 0, $x, $y, $z, $h);  # Replace 1585 with your boss NPC ID if different
            } else {
                my $remaining = $cooldown_time - ($current_time - $last_hail_time);
                my $min = int($remaining / 60);
                my $sec = $remaining % 60;
                plugin::Whisper("You must wait $min minutes and $sec seconds before hailing again.");
            }
        } else {
            plugin::Whisper("You need to hand in the required item before proceeding.");
        }
    }
}