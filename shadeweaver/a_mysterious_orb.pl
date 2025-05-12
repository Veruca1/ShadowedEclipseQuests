sub EVENT_SPAWN {
    quest::spawn2(1461, 0, 0, -2796.76, -1428.81, -180.04, 0);
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $spawn_flag = "${char_id}-shadeweaver_spawn_flag";
    my $cooldown_flag = "${char_id}-shadeweaver_cooldown";

    if ($text=~/hail/i) {
        if (quest::get_data($spawn_flag)) {
            if (quest::get_data($cooldown_flag)) {
                plugin::Whisper("The shade stirs, but you must wait before disturbing it again.");
                plugin::Whisper("Time remaining: " . get_cooldown_remaining($char_id));
            } else {
                plugin::Whisper("The time is right. The shade awaits.");
            }
        } else {
            plugin::Whisper("Greetings, adventurer. Only those bearing the symbol and the heat source may proceed.");
        }
    }
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();
    my $spawn_flag = "${char_id}-shadeweaver_spawn_flag";
    my $cooldown_flag = "${char_id}-shadeweaver_cooldown";
    my $cooldown_time_flag = "${char_id}-shadeweaver_cd_start";

    if (plugin::check_handin(\%itemcount, 14941 => 1, 33200 => 1)) {
        plugin::Whisper("The shade awakens...");

        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        quest::spawn2(1459, 0, 0, $x, $y, $z, $h);  # Spawn the Shadeweaver

        quest::set_data($spawn_flag, 1);
        quest::set_data($cooldown_flag, 1);
        quest::set_data($cooldown_time_flag, time);
        quest::settimer("shadeweaver_cd_$char_id", 600);  # 10-minute cooldown
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_TIMER {
    if ($timer =~ /^shadeweaver_cd_(\d+)$/) {
        my $char_id = $1;
        my $cooldown_flag = "${char_id}-shadeweaver_cooldown";
        my $cooldown_time_flag = "${char_id}-shadeweaver_cd_start";

        quest::delete_data($cooldown_flag);
        quest::delete_data($cooldown_time_flag);
        quest::stoptimer($timer);
    }
}

sub get_cooldown_remaining {
    my $char_id = shift;
    my $cooldown_time_flag = "${char_id}-shadeweaver_cd_start";
    my $start_time = quest::get_data($cooldown_time_flag);

    if ($start_time) {
        my $elapsed = time - $start_time;
        my $remaining = 600 - $elapsed;
        $remaining = 0 if $remaining < 0;

        my $minutes = int($remaining / 60);
        my $seconds = $remaining % 60;
        return sprintf("%02d minute(s) and %02d second(s)", $minutes, $seconds);
    }

    return "Unknown";
}
