sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text && defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $flag_key = "mons_earth_boss_charid";
    my $cd_key = "${char_id}_mons_earth_boss_cd";
    my $cooldown = 600;

    if ($text =~ /hail/i) {
        if (!quest::get_data($flag_key)) {
            plugin::Whisper("You are not attuned to summon the elemental guardian.");
            return;
        }

        my $last_time = quest::get_data($cd_key) || 0;
        my $elapsed = time - $last_time;

        if ($elapsed < $cooldown) {
            my $remaining = $cooldown - $elapsed;
            plugin::Whisper("The elemental slumbers. Time remaining: " . format_time($remaining));
        } else {
            quest::spawn2(169127, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
            quest::set_data($cd_key, time);
            plugin::Whisper("The ground cracks open as the elemental guardian rises!");
        }
    }
}

sub EVENT_ITEM {
    return unless defined $client && $client->IsClient();
    return unless defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $flag_key = "mons_earth_boss_charid";
    my $cd_key = "${char_id}_mons_earth_boss_cd";
    my $cooldown = 600;

    if (plugin::check_handin(\%itemcount, 12345 => 1)) {
        quest::set_data($flag_key, 1);
        plugin::Whisper("You feel a tremor deep beneath the earth... something ancient stirs.");
    }

    elsif (quest::get_data($flag_key)) {
        my $last_time = quest::get_data($cd_key) || 0;
        my $elapsed = time - $last_time;

        if ($elapsed < $cooldown) {
            my $remaining = $cooldown - $elapsed;
            plugin::Whisper("The earth must rest before it stirs again. Time remaining: " . format_time($remaining));
            plugin::return_items(\%itemcount);
            return;
        }

        quest::spawn2(169127, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        quest::set_data($cd_key, time);
        plugin::Whisper("The earth rumbles violently as the guardian emerges...");
    }

    plugin::return_items(\%itemcount);
}

sub format_time {
    my $seconds = shift // 0;
    my $minutes = int($seconds / 60);
    $seconds = $seconds % 60;
    return sprintf("%02d minute(s) and %02d second(s)", $minutes, $seconds);
}