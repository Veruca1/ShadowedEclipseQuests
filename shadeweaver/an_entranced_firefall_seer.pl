sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "${char_id}-firefall_spawn_flag";
    my $cooldown_time_flag = "${char_id}-firefall_cd_start";
    my $cd_duration = 300; # 5 minutes

    if ($text =~ /hail/i) {
        if (quest::get_data($spawn_flag)) {
            my $remaining = get_cooldown_remaining($char_id, $cd_duration);
            if ($remaining > 0) {
                my $fmt = format_time($remaining);
                plugin::Whisper("The fire burns hot, but the flames must rest. Please wait a little longer before you summon the Wildfire.");
                plugin::Whisper("Time remaining: $fmt");
            } else {
                plugin::Whisper("The flame burns with vigor. You may proceed!");
                quest::spawn2(165295, 0, 0, 358.02, 3687.48, -318.09, 383.25);
                quest::set_data($cooldown_time_flag, time);
            }
        } else {
            plugin::Whisper("Greetings, traveler. Only those with a singular flame may awaken the elemental force slumbering here.");
        }
    }
}

sub EVENT_ITEM {
    return unless defined $client && $client->IsClient();

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "${char_id}-firefall_spawn_flag";
    my $cooldown_time_flag = "${char_id}-firefall_cd_start";
    my $cd_duration = 300;

    if (plugin::check_handin(\%itemcount, 33201 => 1)) {
        plugin::Whisper("Ah, you bring the flame! The symbol is now ready. The fire shall burn away the cold and reveal its true nature.");

        quest::spawn2(165295, 0, 0, 358.02, 3687.48, -318.09, 383.25);

        my $npc = $entity_list->GetMobByNpcTypeID(165295);
        if ($npc) {
            quest::set_data($spawn_flag, 1);
            quest::set_data($cooldown_time_flag, time);
        } else {
            plugin::Whisper("Something has gone wrong — the fire could not be summoned. Try again later or contact a GM.");
        }
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub get_cooldown_remaining {
    my ($char_id, $duration) = @_;
    my $cooldown_time_flag = "${char_id}-firefall_cd_start";
    my $start_time = quest::get_data($cooldown_time_flag);

    return 0 unless $start_time;
    my $elapsed = time - $start_time;
    my $remaining = $duration - $elapsed;
    return ($remaining > 0) ? $remaining : 0;
}

sub format_time {
    my $seconds = shift;
    my $minutes = int($seconds / 60);
    $seconds = $seconds % 60;
    return sprintf("%02d minute(s) and %02d second(s)", $minutes, $seconds);
}
