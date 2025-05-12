sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $flag = "$char_id-vel_bunny_event";  # Updated flag name
    my $cooldown_flag = "$char_id-vel_bunny_cooldown";  # Updated cooldown flag
    my $cooldown_time = 600;  # 10-minute cooldown

    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            my $ready_link = quest::saylink("READY", 1);
            quest::whisper("You’re ready to summon the Easter Bunny! Say $ready_link when you are prepared.");
        } else {
            quest::whisper("I need a basket to prepare the Easter Bunny’s arrival. Bring me one, and I’ll make it happen.");
        }
    }

    if ($text =~ /ready/i && quest::get_data($flag)) {
        my $last_summon_time = quest::get_data($cooldown_flag);
        my $current_time = time();

        if (!$last_summon_time || ($current_time - $last_summon_time) > $cooldown_time) {
            quest::set_data($cooldown_flag, $current_time);
            quest::whisper("Get ready... the Easter Bunny is on the way!");
            quest::spawn2(30106, 0, 0, -1211.03, -2064.74, -210.94, 203);
        } else {
            my $remaining_time = $cooldown_time - ($current_time - $last_summon_time);
            my $minutes = int($remaining_time / 60);
            my $seconds = $remaining_time % 60;
            quest::whisper("You must wait $minutes minutes and $seconds seconds before summoning the Easter Bunny again.");
        }
    }
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();
    my $flag = "$char_id-vel_bunny_event";  # Updated flag name

    if (plugin::check_handin(\%itemcount, 957 => 1)) {  # Updated item ID to 957
        quest::set_data($flag, 1);
        my $ready_link = quest::saylink("READY", 1);
        quest::whisper("Ah, a perfect basket! You're ready to summon the Easter Bunny. Say $ready_link when you are ready.");
    } else {
        quest::whisper("This isn’t what I need. Bring me a basket if you want to summon the Easter Bunny.");
        plugin::return_items(\%itemcount);
    }
}
