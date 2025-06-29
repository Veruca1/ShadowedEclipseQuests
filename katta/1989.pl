sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text && defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "kattan_banner_flag_${char_id}";
    my $cd_time_flag = "${char_id}-kattan_banner_cd_start";
    my $cd_duration = 600; # 10 minutes

    if ($text =~ /hail/i) {
        if (quest::get_data($spawn_flag)) {
            my $remaining = get_cooldown_remaining($char_id, $cd_duration);
            if ($remaining > 0) {
                plugin::Whisper("The battle standard cannot be raised yet.");
                plugin::Whisper("Time remaining: " . format_time($remaining));
            } else {
                unless (npc_already_spawned(160375)) {
                    plugin::Whisper("The Kattan Banner waves once more...");
                    quest::spawn2(1992, 0, 0, -73.83, -203.63, 67.80, 131.50);
                    quest::set_data($cd_time_flag, time);
                } else {
                    plugin::Whisper("The Kattan Banner is already present.");
                }
            }
        } else {
            plugin::Whisper("You are not yet loyal enough to raise the Kattan Banner.");
        }
    }
}

sub EVENT_ITEM {
    return unless defined $client && $client->IsClient();
    return unless defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "kattan_banner_flag_${char_id}";
    my $cd_time_flag = "${char_id}-kattan_banner_cd_start";
    my $cd_duration = 600;

    if (plugin::check_handin(\%itemcount, 42470 => 1)) {
        if (npc_already_spawned(160375)) {
            plugin::Whisper("The Kattan Banner is already summoned. Let it fall before raising it again.");
            plugin::return_items(\%itemcount);
            return;
        }

        plugin::Whisper("You plant the Symbol of Loyalty... the Kattan Banner rises in response.");
        quest::set_data($spawn_flag, 1);
        quest::set_data($cd_time_flag, time);
        quest::spawn2(1992, 0, 0, -73.83, -203.63, 67.80, 131.50);
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub npc_already_spawned {
    my ($npc_id) = @_;
    return defined $entity_list->GetMobByNpcTypeID($npc_id);
}

sub get_cooldown_remaining {
    my ($char_id, $cd_duration) = @_;
    return 0 unless defined $char_id && defined $cd_duration;

    my $cd_time_flag = "${char_id}-kattan_banner_cd_start";
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