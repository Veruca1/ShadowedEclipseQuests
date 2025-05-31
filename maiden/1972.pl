sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text && defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "maidens_bastion_${char_id}";
    my $cd_time_flag = "${char_id}-maidens_bastion_cd_start";
    my $cd_duration = 600; # 10 minutes

    if ($text =~ /hail/i) {
        if (quest::get_data($spawn_flag)) {
            my $remaining = get_cooldown_remaining($char_id, $cd_duration);
            if ($remaining > 0) {
                plugin::Whisper("You must wait before the bastion answers your call again.");
                plugin::Whisper("Time remaining: " . format_time($remaining));
            } else {
                unless (npc_already_spawned(1973)) {
                    plugin::Whisper("The Bastion awakens once more...");
                    spawn_maidens_bastion();
                    quest::set_data($cd_time_flag, time);
                } else {
                    plugin::Whisper("The Bastion is already present...");
                }
            }
        } else {
            plugin::Whisper("You are not attuned to the Bastion.");
        }
    }
}

sub EVENT_ITEM {
    return unless defined $client && $client->IsClient();
    return unless defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $spawn_flag = "maidens_bastion_${char_id}";
    my $cd_time_flag = "${char_id}-maidens_bastion_cd_start";
    my $cd_duration = 600;

    if (plugin::check_handin(\%itemcount, 40809 => 1, 40810 => 1, 40811 => 1)) {
        if (npc_already_spawned(1973)) {
            plugin::Whisper("The Bastion is already summoned. Wait until the current challenge is complete.");
            plugin::return_items(\%itemcount);
            return;
        }

        plugin::Whisper("You feel the world tremble as the Bastion rises...");
        quest::set_data($spawn_flag, 1);
        quest::set_data($cd_time_flag, time);
        spawn_maidens_bastion();
    } else {
        plugin::return_items(\%itemcount);
    }
}

sub spawn_maidens_bastion {
    my @spawn_locs = (
        [703.63, 1552.73, -154.43, 501.75],
        [670.71, 1531.16, -154.44, 30.50],
        [708.54, 1470.83, -154.40, 480.75],
        [638.58, 1444.26, -154.34, 64.00],
        [573.76, 1606.49, -154.44, 314.00],
        [439.62, 1511.23, -154.44, 58.75],
        [577.55, 1496.09, -154.44, 439.50],
        [439.99, 1400.54, -150.07, 78.00],
        [437.88, 1468.34, -150.00, 148.75],
        [577.79, 1468.42, -154.44, 346.25],
        [146.31, 1398.67, -153.03, 156.00],
        [160.53, 1293.66, -150.59, 58.25],
        [260.07, 1295.65, -150.59, 454.00],
        [148.29, 1188.43, -150.59, 72.50],
        [146.30, 1262.82, -150.59, 150.25],
        [255.07, 1197.07, -150.59, 429.75],
        [351.67, 1394.21, -150.59, 329.50],
        [292.54, 1292.12, -150.59, 48.75],
        [363.20, 1293.76, -154.75, 413.25],
        [523.23, 1073.64, -154.50, 40.25],
        [522.50, 1174.74, -154.50, 213.00],
        [645.46, 1111.74, -160.90, 323.00],
        [765.99, 1266.69, -154.50, 307.00],
        [636.11, 1262.66, -154.50, 175.50],
        [764.49, 1080.89, -154.50, 464.00],
        [653.67, 1130.30, -140.34, 56.25],
    );

    my @random_1974_locs = (
        [689.10, 1178.94, -154.50, 421.50],
        [667.33, 1406.80, -154.34, 506.75],
        [558.97, 1078.48, -147.96, 506.25],
        [555.00, 1243.62, -154.50, 237.25],
        [513.16, 1541.43, -154.43, 224.75],
        [475.39, 1405.78, -150.04, 13.50],
        [197.57, 1342.48, -150.03, 365.50],
        [336.17, 1340.69, -150.03, 253.75],
        [214.61, 1227.54, -150.03, 251.75],
    );

    # Spawn 1973 at all fixed locations
    foreach my $loc (@spawn_locs) {
        quest::spawn2(1973, 0, 0, @$loc);
    }

    # Spawn 1937 at fixed location (bystander)
    quest::spawn2(1937, 0, 0, -13.01, 1526.81, -75.26, 260);

    # Randomly choose one location for 1974
    my $random_loc = $random_1974_locs[int(rand(@random_1974_locs))];
    quest::spawn2(1975, 0, 0, @$random_loc);
}

sub npc_already_spawned {
    my ($npc_id) = @_;
    return defined $entity_list->GetMobByNpcTypeID($npc_id);
}

sub get_cooldown_remaining {
    my ($char_id, $cd_duration) = @_;
    return 0 unless defined $char_id && defined $cd_duration;

    my $cd_time_flag = "${char_id}-maidens_bastion_cd_start";
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