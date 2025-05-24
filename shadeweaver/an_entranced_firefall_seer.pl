sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "${char_id}-firefall_spawn_flag";
    my $cooldown_flag = "${char_id}-firefall_cooldown";
    my $cd_duration = 300; # 5 minutes cooldown

    if ($text =~ /hail/i) {
        if (quest::get_data($spawn_flag)) {
            if (quest::get_data($cooldown_flag)) {
                plugin::Whisper("The fire burns hot, but the flames must rest. Please wait a little longer before you summon the Wildfire.");
                plugin::Whisper("Time remaining: " . get_cooldown_remaining($char_id));
            } else {
                plugin::Whisper("The flame burns with vigor. You may proceed!");
                quest::spawn2(165295, 0, 0, 358.02, 3687.48, -318.09, 383.25);
                quest::set_data($cooldown_flag, 1);
                quest::set_data("${char_id}-firefall_cd_start", time);
                quest::settimer("firefall_cd_$char_id", $cd_duration);
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
    my $cooldown_flag = "${char_id}-firefall_cooldown";
    my $cooldown_time_flag = "${char_id}-firefall_cd_start";

    if (plugin::check_handin(\%itemcount, 33201 => 1)) {
        plugin::Whisper("Ah, you bring the flame! The symbol is now ready. The fire shall burn away the cold and reveal its true nature.");

        quest::spawn2(165295, 0, 0, 358.02, 3687.48, -318.09, 383.25);

        if ($entity_list) {
            my $npc = $entity_list->GetMobByNpcTypeID(165295);
            if ($npc) {
                quest::set_data($spawn_flag, 1);
                quest::set_data($cooldown_flag, 1);
                quest::set_data($cooldown_time_flag, time);
                quest::settimer("firefall_cd_$char_id", 300);
            } else {
                plugin::Whisper("Something has gone wrong — the fire could not be summoned. Try again later or contact a GM.");
            }
        } else {
            plugin::Whisper("Entity list unavailable — cannot verify spawn. Contact a GM.");
        }
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_TIMER {
    return unless defined $timer;
    if ($timer =~ /^firefall_cd_(\d+)$/) {
        my $char_id = $1;
        my $cooldown_flag = "${char_id}-firefall_cooldown";
        my $cooldown_time_flag = "${char_id}-firefall_cd_start";

        quest::delete_data($cooldown_flag);
        quest::delete_data($cooldown_time_flag);
        quest::stoptimer($timer);
    }
}

sub get_cooldown_remaining {
    my $char_id = shift;
    return "Unknown" unless defined $char_id;

    my $cooldown_time_flag = "${char_id}-firefall_cd_start";
    my $start_time = quest::get_data($cooldown_time_flag);

    if ($start_time) {
        my $elapsed = time - $start_time;
        my $remaining = 300 - $elapsed;
        $remaining = 0 if $remaining < 0;

        my $minutes = int($remaining / 60);
        my $seconds = $remaining % 60;
        return sprintf("%02d minute(s) and %02d second(s)", $minutes, $seconds);
    }

    return "Unknown";
}