sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $flag = "$char_id-spider_event_flag";
    my $cooldown_key = "$char_id-spider_event_cooldown";
    my $cooldown_time = 420;  # 7 minutes in seconds

    if ($text =~ /hail/i) {
        if (quest::get_data($flag)) {
            plugin::Whisper("The bones of the surrounding scaled ones stir with the power of these carapaces... Are you ready? If so, click " . quest::saylink("READY") . " and prepare yourself for the ritual.");
        } else {
            plugin::Whisper("I cannot do anything for you until I have 4 Pristine Phase Spider Carapaces.");
        }
    }

    if ($text =~ /READY/i) {
        my $last_attempt_time = quest::get_data($cooldown_key);
        my $current_time = time();

        if (!$last_attempt_time || ($current_time - $last_attempt_time) > $cooldown_time) {
            quest::set_data($cooldown_key, $current_time);
            quest::set_data($flag, 1);

            plugin::Whisper("The bones of the surrounding scaled ones draw power from the velium cores used to create these carapaces. The results await you in these three huts!");

            if (!quest::isnpcspawned(123015)) { quest::spawn2(123015, 0, 0, 1031.48, 911.95, 11.97, 218.75); }
            if (!quest::isnpcspawned(1798)) { quest::spawn2(1798, 0, 0, 679.23, 651.42, 11.97, 89.25); }
            if (!quest::isnpcspawned(1797)) { quest::spawn2(1797, 0, 0, 374.72, 725.64, 11.29, 0.50); }
        } else {
            my $time_left = $cooldown_time - ($current_time - $last_attempt_time);
            my $minutes_left = int($time_left / 60);
            my $seconds_left = $time_left % 60;

            plugin::Whisper("The bones of the surrounding scaled ones still draw power from the velium cores. Their energy must settle before the ritual can be performed again. You must wait $minutes_left minutes and $seconds_left seconds.");
        }
    }
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();
    my $flag = "$char_id-spider_event_flag";

    if (plugin::check_handin(\%itemcount, 726 => 4)) {
        quest::set_data($flag, 1);
        plugin::Whisper("You have gathered the carapaces. The bones of the surrounding scaled ones stir with power. Hail me when you are ready.");
    } else {
        plugin::return_items(\%itemcount);
    }
}
