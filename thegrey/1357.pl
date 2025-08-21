sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
            "You stand upon *The Grey*. An emptiness sculpted by divine spite and mortal folly.<br><br>" .
            "There is no air here. No life. Only dust... and *her whispers*.<br><br>" .
            "They drift between the stones, the ruins, the broken moonsilk beneath your feet. Some creatures you will see. Others you will only feel—when it's far too late.<br><br>" .
            "You already know how to proceed. The weave has taught you that much. But do not mistake clarity for safety.<br><br>" .
            "Beyond this place lies the *Temple of Ssraeshza*. Those who press forward do so not out of wisdom, but of arrogance.<br><br>" .
            "And if you *must* enter... steer clear of the <c \"#E0A060\">Ring of the Crusader</c>. It slumbers now. But songs still circle the dust—songs of a *knight wrapped in shadow*, who wakes only for those foolish enough to beckon.<br><br>" .
            "He does not parley. He does not pause. He *remembers*.<br><br>" .
            "<c \"#8080C0\">The Chorus does not follow you here. You are alone with the Moon's mistakes.</c>"
        );
        plugin::Whisper("If your curiosity lingers... I can offer you a path into a place untouched. Say [list zones]... or the name of the one that calls to you.");
    }
    elsif ($text =~ /list zones/i) {
        plugin::Whisper("The Chorus offers passage to these echoes of reality:");
        plugin::Whisper("  - " . quest::saylink("The Grey", 1, "The Grey (thegrey)"));
        plugin::Whisper("  - " . quest::saylink("Ssraeshza Temple", 1, "Ssraeshza Temple (ssratemple)"));
    }
    elsif ($text =~ /^(The Grey|Grey|thegrey)$/i) {
        CreateCustomDZ("thegrey", "The Grey");
    }
    elsif ($text =~ /^(Ssraeshza Temple|Ssra|ssratemple)$/i) {
        CreateCustomDZ("ssratemple", "Ssraeshza Temple");
    }
    elsif ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz) {
            my $zone_short = $dz->GetZoneName();
            plugin::Whisper("The veil thins. You are being drawn to: $zone_short.");
            $client->MovePCDynamicZone($zone_short);
        } else {
            plugin::Whisper("You are not yet tethered to an echo. Speak again when you are.");
        }
    }
}

sub CreateCustomDZ {
    my ($shortname, $fullname) = @_;
    my $dz_duration = 86400; # 24 hours duration
    my $min_players = 1;
    my $max_players = 6;
    my $expedition_name = "DZ - $fullname";

    my $dz = $client->CreateExpedition($shortname, 0, $dz_duration, $expedition_name, $min_players, $max_players);
    
    if ($dz) {
        plugin::Whisper("An echo of '$fullname' has been awakened. Say [" . quest::saylink("ready", 1, "ready") . "] when your spirit is prepared.");
    } else {
        plugin::Whisper("This echo remains sealed. Try again or consult the Chorus.");
    }
}