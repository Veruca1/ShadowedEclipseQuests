sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text && defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "overfiend_spawn_${char_id}";
    my $cd_time_flag = "${char_id}-overfiend_cd_start";
    my $cd_duration = 600; # 10 minutes

    if ($text =~ /hail/i) {
        if (quest::get_data($spawn_flag)) {
            my $remaining = get_cooldown_remaining($char_id, $cd_duration);
            if ($remaining > 0) {
                plugin::Whisper("The Overfiend stirs, but you must wait before summoning it again.");
                plugin::Whisper("Time remaining: " . format_time($remaining));
            } else {
                unless ($entity_list->GetMobByNpcTypeID(1947)) {
                    plugin::Whisper("The time is right. The Overfiend awaits.");
                    quest::spawn2(1947, 0, 0, 2259.32, -989.15, -61.31, 0.50);
                    quest::set_data($cd_time_flag, time);
                } else {
                    plugin::Whisper("The Overfiend is already present...");
                }
            }
        } else {
            plugin::Whisper("You lack the proper components to call forth the Overfiend.");
        }
    }
}

sub EVENT_ITEM {
    return unless defined $client && $client->IsClient();
    return unless defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "overfiend_spawn_${char_id}";
    my $cd_time_flag = "${char_id}-overfiend_cd_start";
    my $cd_duration = 600; # 10 minutes

    if (plugin::check_handin(\%itemcount, 40805 => 1, 40806 => 1, 40807 => 1, 40808 => 1)) {
        if ($entity_list->GetMobByNpcTypeID(1947)) {
            plugin::Whisper("The Overfiend is already present. Wait until it has been defeated.");
            plugin::return_items(\%itemcount);
            return;
        }

        plugin::Whisper("The Overfiend rises from the shadows...");

        quest::spawn2(1947, 0, 0, 2259.32, -989.15, -61.31, 0.50);
        quest::set_data($spawn_flag, 1);
        quest::set_data($cd_time_flag, time);
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub get_cooldown_remaining {
    my ($char_id, $cd_duration) = @_;
    return 0 unless defined $char_id && defined $cd_duration;

    my $cd_time_flag = "${char_id}-overfiend_cd_start";
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