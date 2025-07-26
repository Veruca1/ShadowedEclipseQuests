sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
    "Ah... *Scarlet Desert*. Burnt and bleeding, yet still the seekers come.<br><br>" .
    "Once, the ambitious passed through here—Wizards, scholars, zealots—all chasing whispers of a great gem. But the gem is gone now. It left behind only <c \"#FFD700\">Sun</c>.<br><br>" .
    "Do not mourn the gem. The <c \"#FFD700\">Sun</c> watches. The <c \"#FFD700\">Sun</c> tests. The <c \"#FFD700\">Sun</c> *remembers*.<br><br>" .
    "The Oracle once studied its passage from this very wasteland. Even Luclin herself is said to have turned her gaze here, if only for a moment. That moment may yet echo.<br><br>" .
    "You will not need keys here. No, the gates respond now to essence—those wrung from the dust and bone of this forsaken place. The <c \"#D08080\">lesser minions</c> still scurry, and <c \"#C070B0\">those who would lead them</c> still cling to purpose.<br><br>" .
    "Take their remnants. Refine them. Let your vessel know heat and burden.<br><br>" .
    "And if you feel the <c \"#FFD700\">Sun</c> upon you, do not cower. There is great risk in fire... but even greater reward.<br><br>" .
    "<c \"#FFD780\">It sees you.</c><br>" .
    "<c \"#8080C0\">The Chorus watches.</c>"
);
        plugin::Whisper("If your curiosity lingers... I can offer you a path into a place untouched. Say [list zones]... or the name of the one that calls to you.");
    }
    elsif ($text =~ /list zones/i) {
        plugin::Whisper("The Chorus offers passage to these echoes of reality:");
        plugin::Whisper("  - " . quest::saylink("Scarlet Desert", 1, "Scarlet Desert (scarlet)"));
        plugin::Whisper("  - " . quest::saylink("Letalis", 1, "Letalis (letalis)"));
    }
    elsif ($text =~ /^(Scarlet|Scarlet Desert|scarlet)$/i) {
        CreateCustomDZ("scarlet", "Scarlet Desert");
    }
    elsif ($text =~ /^(Letalis|letalis)$/i) {
        CreateCustomDZ("letalis", "Letalis");
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
    my $dz_duration = 14400; # 4 hours duration
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
