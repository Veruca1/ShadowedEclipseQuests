sub EVENT_SPAWN {
    quest::spawn2(1461, 0, 0, -2796.76, -1428.81, -180.04, 0);
}

sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text && defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "shadeweaver_boss_spawn_${char_id}";
    my $cd_time_flag = "${char_id}-shadeweaver_boss_cd_start";
    my $cd_duration = 600; # 10 minutes

    if ($text =~ /hail/i) {
        if (quest::get_data($spawn_flag)) {
            my $remaining = get_cooldown_remaining($char_id, $cd_duration);
            if ($remaining > 0) {
                plugin::Whisper("The shade stirs, but you must wait before disturbing it again.");
                plugin::Whisper("Time remaining: " . format_time($remaining));
            } else {
                unless ($entity_list->GetMobByNpcTypeID(1459)) {
                    plugin::Whisper("The time is right. The shade awaits.");

                    my $x = $npc->GetX() // 0;
                    my $y = $npc->GetY() // 0;
                    my $z = $npc->GetZ() // 0;
                    my $h = $npc->GetHeading() // 0;

                    quest::spawn2(1459, 0, 0, $x, $y, $z, $h);
                    quest::set_data($cd_time_flag, time);
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
    return unless defined $client && $client->IsClient();
    return unless defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "shadeweaver_boss_spawn_${char_id}";
    my $cd_time_flag = "${char_id}-shadeweaver_boss_cd_start";
    my $cd_duration = 600; # 10 minutes

    if (plugin::check_handin(\%itemcount, 14941 => 1, 33200 => 1)) {
        if ($entity_list->GetMobByNpcTypeID(1459)) {
            plugin::Whisper("The shade is already present. Wait until it has been defeated.");
            plugin::return_items(\%itemcount);
            return;
        }

        plugin::Whisper("The shade awakens...");

        my $x = $npc->GetX() // 0;
        my $y = $npc->GetY() // 0;
        my $z = $npc->GetZ() // 0;
        my $h = $npc->GetHeading() // 0;

        quest::spawn2(1459, 0, 0, $x, $y, $z, $h);
        quest::set_data($spawn_flag, 1);
        quest::set_data($cd_time_flag, time);
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub get_cooldown_remaining {
    my ($char_id, $cd_duration) = @_;
    return 0 unless defined $char_id && defined $cd_duration;

    my $cd_time_flag = "${char_id}-shadeweaver_boss_cd_start";
    my $start_time = quest::get_data($cd_time_flag);
    return 0 unless $start_time;

    my $elapsed = time - $start_time;
    my $remaining = $cd_duration - $elapsed;
    return $remaining > 0 ? $remaining : 0;
}

sub format_time {
    my $seconds = shift // 0;
    my $minutes = int($seconds / 60);
    $seconds = $seconds % 60;
    return sprintf("%02d minute(s) and %02d second(s)", $minutes, $seconds);
}