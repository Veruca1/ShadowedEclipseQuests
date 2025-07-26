sub EVENT_SAY {
    return unless defined $client && $client->IsClient();
    return unless defined $text && defined $npc;

    my $char_id = $client->CharacterID();
    return unless defined $char_id;

    my $cd_key = "${char_id}_mons_earth_boss_cd";
    my $cooldown = 600;

    if ($text =~ /hail/i) {
        my $last_time = quest::get_data($cd_key) || 0;
        my $elapsed = time - $last_time;

        if ($elapsed < $cooldown) {
            my $remaining = $cooldown - $elapsed;
            plugin::Whisper("The elemental slumbers. Time remaining: " . format_time($remaining));
            return;
        }

        # Check if boss already exists
        my $boss_id = 169127;
        my $existing = $entity_list->GetMobByNpcTypeID($boss_id);
        if ($existing) {
            plugin::Whisper("The elemental is already awakened. Wait until it returns to the earth.");
            return;
        }

        quest::spawn2($boss_id, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        quest::set_data($cd_key, time);
        plugin::Whisper("The ground cracks open as the elemental guardian rises!");
    }
}

sub EVENT_ITEM {
    plugin::return_items(\%itemcount); # No item hand-ins needed
}

sub format_time {
    my $seconds = shift // 0;
    my $minutes = int($seconds / 60);
    $seconds = $seconds % 60;
    return sprintf("%02d minute(s) and %02d second(s)", $minutes, $seconds);
}