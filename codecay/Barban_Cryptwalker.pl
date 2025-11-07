# Barban_Cryptwalker

sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $has_flag = $client->HasZoneFlag(204);  # CoD (Crypt of Decay) flag
    my $has_carp_flag = ($qglobals{"pop_cod_preflag"} && $qglobals{"pop_cod_preflag"} == 1);
    my $instance_id = $client->GetInstanceID();

    quest::debug("EVENT_SAY triggered for char_id: $char_id");
    quest::debug("HasZoneFlag(200) = " . ($has_flag ? "true" : "false"));
    quest::debug("Has Carprin Flag (pop_cod_preflag) = " . ($has_carp_flag ? "true" : "false"));
    quest::debug("Instance ID = $instance_id");

    if ($text=~/Hail/i) {
        if ($has_flag || $has_carp_flag) {
            my @options;

            if ($has_flag) {
                push @options, "[" . quest::saylink("challenge Bertoxxulous") . "]";
            } else {
                quest::whisper("You do not have access to summon Bertoxxulous here.");
            }

            if ($has_carp_flag) {
                push @options, "[" . quest::saylink("go to Bertoxxulous") . "]";
            }

            my $list = join(" or ", @options);
            quest::whisper("You believe you are ready, mortal? You may $list.");
        } else {
            quest::whisper("You are not yet ready to face him.");
        }
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

    if ($text=~/Go to Bertoxxulous/i && $has_carp_flag) {
        if ($instance_id > 0) {
            quest::whisper("Very well. Prepare yourself...");
            # Move to Bertox area in Crypt of Decay (zone ID 200), inside the same DZ instance
            $client->MovePCInstance(200, $instance_id, -16, 0, -290, 0);
        } else {
            quest::whisper("You must be in a dynamic zone instance to enter the ritual chamber.");
        }
    }
}