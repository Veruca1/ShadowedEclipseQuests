# NPCID 1321 - Old Glowing Bones
# Spawns Vampire Lord Chosooth at a fixed location on hail with a 5-minute cooldown.
# Informs player of cooldown time on repeat hails.

sub EVENT_SPAWN {
    quest::set_proximity($x - 1, $x + 1, $y - 1, $y + 1, $z - 1, $z + 1);
}

sub EVENT_ENTER {
    quest::emote("You sense these bones should not be disturbed.");
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();
    my $chosooth_lock = $client->GetBucket("chosooth_lockout");

    if ($text =~ /hail/i) {
        if (!$chosooth_lock) {
            quest::say("The bones begin to glow brighter and shake violently...");
            $client->SetBucket("chosooth_lockout", 1, 60); # 1-minute lockout

            # Spawn Vampire Lord Chosooth at fixed location
            quest::spawn2(1319, 0, 0, -603.84, 5.35, -109.27, 0);
        } else {
            my $time_left = $client->GetBucketRemaining("chosooth_lockout");
            quest::say("The bones pulse faintly. You must wait [" . quest::secondstotime($time_left) . "] before disturbing them again.");
        }
    }
}