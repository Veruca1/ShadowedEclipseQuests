sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text;

    my $char_id = $client->CharacterID();
    my $spawn_flag = "twilight_secret_event_${char_id}";
    my $cd_time_flag = "${char_id}-twilight_secret_event_cd_start";
    my $cd_duration = 600;  # 10 minutes

    if ($text =~ /hail/i) {
        if (quest::get_data($spawn_flag)) {
            my $remaining = get_cooldown_remaining($char_id, $cd_duration);
            if ($remaining > 0) {
                plugin::Whisper("You must wait before disturbing the secret again.");
                plugin::Whisper("Time remaining: " . format_time($remaining));
            } else {
                my $saylink = quest::saylink("spawn the experiment", 1);
                plugin::Whisper("The shadows shudder. Will you $saylink?");
            }
        } else {
            plugin::Whisper("The secret remains locked to you.");
        }
    }

    if ($text =~ /spawn the experiment/i) {
        if (quest::get_data($spawn_flag)) {
            my $remaining = get_cooldown_remaining($char_id, $cd_duration);
            if ($remaining > 0) {
                plugin::Whisper("Patience. The secret needs time.");
                plugin::Whisper("Time remaining: " . format_time($remaining));
                return;
            }

            plugin::Whisper("The shadows part and something stirs...");
            quest::set_data($cd_time_flag, time);
            quest::spawn2(2166, 0, 0, 35.00, 3015.38, 8.73, 488.00);
        }
    }
}

sub EVENT_ITEM {
    return unless defined $client && $client->IsClient();
    my $char_id = $client->CharacterID();

    if (plugin::check_handin(\%itemcount, 42687 => 1)) {
        quest::set_data("twilight_secret_event_${char_id}", 1);
        quest::set_data("${char_id}-twilight_secret_event_cd_start", time - 600);
        plugin::Whisper("You feel the secret unlock within you...");
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub get_cooldown_remaining {
    my ($char_id, $cd_duration) = @_;
    my $cd_flag = "${char_id}-twilight_secret_event_cd_start";
    my $start = quest::get_data($cd_flag);
    return 0 unless $start;
    my $elapsed = time - $start;
    return $cd_duration > $elapsed ? $cd_duration - $elapsed : 0;
}

sub format_time {
    my $s = shift // 0;
    my $m = int($s / 60);
    $s %= 60;
    return sprintf("%02d minute(s) and %02d second(s)", $m, $s);
}