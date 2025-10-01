sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $has_flag = $client->HasZoneFlag(204);  # PoN flag
    quest::debug("EVENT_SAY triggered for char_id: $char_id");
    quest::debug("HasZoneFlag(204) = " . ($has_flag ? "true" : "false"));

    if ($text=~/Hail/i && $has_flag) {
        quest::whisper("You believe you can [" . quest::saylink("challenge Bertoxxulous") . "], mortal?");
    } elsif ($text=~/Hail/i) {
        quest::whisper("You are not yet ready to face him.");
    }

    if ($text=~/Challenge Bertoxxulous/i && $has_flag) {
        my $cooldown_key = "bert_challenge_cd_$char_id";
        my $current_time = time();
        my $cd_expire_time = $qglobals{$cooldown_key};

        if (!defined($cd_expire_time) || $cd_expire_time < $current_time) {
            quest::whisper("Give the Crypt Lord my regards.");
            quest::spawn2(200055, 0, 0, -98.03, -62.91, -93.94, 27);  # Bertox NPC ID
            quest::setglobal($cooldown_key, $current_time + 300, 5, "F");  # 5-minute cooldown
        } else {
            my $remaining = $cd_expire_time - $current_time;
            my $minutes = int($remaining / 60);
            my $seconds = $remaining % 60;
            quest::whisper("The ritual is not yet ready. Return in $minutes minute(s) and $seconds second(s).");
        }
    }
}