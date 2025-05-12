sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $vulak_flag = "${char_id}-vulak_spawn_flag";
    my $vulak_lock = $client->GetBucket("-vulak_lockout");
    my $vulak_link = quest::saylink("VULAK", 1, "Vulak");

    my $vulak_id = 1275;
    my $x = -739.4;
    my $y = 517.2;
    my $z = 121;
    my $h = 510;

    if ($text =~ /hail/i) {
        plugin::Whisper("You approach the ancient altar of awakening. Should you wish to face Vulak`Aerr, the final test of might, you must first prove yourself.");

        if (quest::get_data($vulak_flag)) {
            if (!$vulak_lock) {
                plugin::Whisper("You have proven yourself. When you are ready, say $vulak_link to summon Vulak`Aerr.");
            } else {
                my $time_left = $client->GetBucketRemaining("-vulak_lockout");
                plugin::Whisper("You must wait [" . quest::secondstotime($time_left) . "] to summon Vulak again.");
            }
        }
    }

    if ($text =~ /vulak/i) {
        if (quest::get_data($vulak_flag)) {
            if (!$vulak_lock) {
                plugin::Whisper("So be it. Vulak`Aerr awakens!");
                $client->SetBucket("-vulak_lockout", 1, 900); # 15-minute lockout

                quest::spawn2($vulak_id, 0, 0, $x, $y, $z, $h);
            } else {
                my $time_left = $client->GetBucketRemaining("-vulak_lockout");
                plugin::Whisper("The ritual energies are still stabilizing. Time remaining: [" . quest::secondstotime($time_left) . "].");
            }
        } else {
            plugin::Whisper("You are not yet worthy to summon Vulak`Aerr.");
        }
    }
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();
    my $vulak_flag = "${char_id}-vulak_spawn_flag";
    my $vulak_link = quest::saylink("VULAK", 1, "Vulak");

    if (plugin::check_handin(\%itemcount, 30582 => 1)) {
        quest::set_data($vulak_flag, 1);
        plugin::Whisper("You have proven your strength. When you are ready, say $vulak_link to summon Vulak`Aerr.");
    } else {
        plugin::return_items(\%itemcount);
    }
}
