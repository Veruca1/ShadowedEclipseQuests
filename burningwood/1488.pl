sub EVENT_ITEM {
    my $char_id = $client->CharacterID();
    my $item_id = 370;  # Burning Portal Stone
    my $flag = "${char_id}-burningwoodflag";
    my $cooldown_key = "${char_id}-burningwood_item_cooldown";
    my $cooldown_time = 1200;  # 20 minutes

    if (plugin::check_handin(\%itemcount, $item_id => 1)) {
        my $last_handin_time = quest::get_data($cooldown_key);
        my $current_time = time();

        if (!$last_handin_time || ($current_time - $last_handin_time) > $cooldown_time) {
            quest::set_data($flag, 1);
            quest::set_data($cooldown_key, $current_time);

            plugin::Whisper("You have done well. You may now simply hail me to proceed in the future.");
        } else {
            my $remaining_time = $cooldown_time - ($current_time - $last_handin_time);
            plugin::Whisper("You must wait before handing in the item again. Time remaining: " . int($remaining_time / 60) . " minutes.");
        }
    }

    plugin::return_items(\%itemcount);
}

sub EVENT_SAY { 
    my $char_id = $client->CharacterID();
    my $flag = "${char_id}-burningwoodflag";
    my $cooldown_key = "${char_id}-burningwood_hail_cooldown";
    my $cooldown_time = 600;  # 10 minutes

    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            my $last_hail_time = quest::get_data($cooldown_key);
            my $current_time = time();

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                quest::set_data($cooldown_key, $current_time);

                plugin::Whisper("Welcome back. Let me trigger the event for you. REMEMBER TO PULL MOBS FAR BACK FROM THE PORTAL!!!");
                quest::settimer("spawn_npc_1489", 10);
            } else {
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                plugin::Whisper("You must wait a little longer before you can trigger this event again. Time remaining: " . int($remaining_time / 60) . " minutes.");
            }
        } else {
            plugin::Whisper("You must complete the hand-in before I can help you.");
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc_1489") {
        quest::stoptimer("spawn_npc_1489");
        quest::spawn2(1489, 0, 0, $x, $y, $z, $h);
    }
}