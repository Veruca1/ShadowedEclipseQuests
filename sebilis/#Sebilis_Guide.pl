sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("Sebilis Guide",
            "Greetings adventurer. You stand before the threshold of the ancient halls of <c \"#FFC000\">Sebilis</c>—citadel of the iksar empire and crypt of its cursed king.<br><br>" .
            "If you seek to test your mettle against the remnants of a once-great civilization, I can offer you a path to an untouched reflection of that place.<br><br>" .
            "Simply say <c \"#70FF70\">sebilis</c> to begin your journey."
        );
        plugin::Whisper("Say " . quest::saylink("sebilis", 1, "sebilis") . " when you are ready to begin.");
    }
    elsif ($text =~ /^(sebilis)$/i) {
        CreateCustomDZ("sebilis", "Sebilis");
    }
    elsif ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz) {
            my $zone_short = $dz->GetZoneName();
            plugin::Whisper("The magic takes hold. You are being drawn to: $zone_short.");
            $client->MovePCDynamicZone($zone_short);
        } else {
            plugin::Whisper("You are not yet tethered to an echo. Speak again when you are.");
        }
    }
}

sub CreateCustomDZ {
    my ($shortname, $fullname) = @_;
    my $dz_duration = 14400; # 4 hours
    my $min_players = 1;
    my $max_players = 6;
    my $expedition_name = "DZ - $fullname";

    my $dz = $client->CreateExpedition($shortname, 0, $dz_duration, $expedition_name, $min_players, $max_players);

    if ($dz) {
        plugin::Whisper("An instance of '$fullname' has been prepared. Say " . quest::saylink("ready", 1, "ready") . " when you are prepared to enter.");
    } else {
        plugin::Whisper("Something prevents the creation of this expedition. Try again or seek guidance.");
    }
}