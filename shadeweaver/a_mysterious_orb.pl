sub EVENT_SPAWN {
    quest::spawn2(1461, 0, 0, -2796.76, -1428.81, -180.04, 0);
}

sub EVENT_SAY {
    return unless $client && $client->IsClient();
    my $char_id = $client->CharacterID();
    my $spawn_flag = "${char_id}-shadeweaver_spawn_flag";
    my $cd_time_flag = "${char_id}-shadeweaver_cd_start";
    my $cd_duration = 600; # 10 minutes

    if ($text =~ /hail/i) {
        if (quest::get_data($spawn_flag)) {
            my $remaining = get_cooldown_remaining($char_id, $cd_duration);
            if ($remaining > 0) {
                plugin::Whisper("The shade stirs, but you must wait before disturbing it again.");
                plugin::Whisper("Time remaining: " . format_time($remaining));
            } else {
                plugin::Whisper("The time is right. The shade awaits.");

                # Only spawn the shade if it's not already up
                unless ($entity_list->GetMobByNpcTypeID(1459)) {
                    my $x = $npc->GetX();
                    my $y = $npc->GetY();
                    my $z = $npc->GetZ();
                    my $h = $npc->GetHeading();
                    quest::spawn2(1459, 0, 0, $x, $y, $z, $h);

                    quest::set_data($cd_time_flag, time);
                    quest::settimer("shadeweaver_cd_$char_id", $cd_duration);
                } else {
                    plugin::Whisper("The shade is already among us...");
                }
            }
        } else {
            plugin::Whisper("Greetings, adventurer. Only those bearing the symbol and the heat source may proceed.");
        }
    }
}

sub EVENT_ITEM {
    return unless $client && $client->IsClient();
    my $char_id = $client->CharacterID();
    my $spawn_flag = "${char_id}-shadeweaver_spawn_flag";
    my $cd_time_flag = "${char_id}-shadeweaver_cd_start";
    my $cd_duration = 600; # 10 minutes

    if (plugin::check_handin(\%itemcount, 14941 => 1, 33200 => 1)) {
        plugin::Whisper("The shade awakens...");

        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        quest::spawn2(1459, 0, 0, $x, $y, $z, $h);  # Spawn the Shadeweaver

        quest::set_data($spawn_flag, 1);
        quest::set_data($cd_time_flag, time);
        quest::settimer("shadeweaver_cd_$char_id", $cd_duration);
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_TIMER {
    if ($timer =~ /^shadeweaver_cd_(\d+)$/) {
        my $char_id = $1;
        my $cd_time_flag = "${char_id}-shadeweaver_cd_start";
        quest::delete_data($cd_time_flag);
        quest::stoptimer($timer);
    }
}

sub get_cooldown_remaining {
    my ($char_id, $cd_duration) = @_;
    my $cd_time_flag = "${char_id}-shadeweaver_cd_start";
    my $start_time = quest::get_data($cd_time_flag);
    return 0 unless $start_time;
    my $elapsed = time - $start_time;
    my $remaining = $cd_duration - $elapsed;
    return $remaining > 0 ? $remaining : 0;
}

sub format_time {
    my $seconds = shift;
    my $minutes = int($seconds / 60);
    $seconds = $seconds % 60;
    return sprintf("%02d minute(s) and %02d second(s)", $minutes, $seconds);
}
