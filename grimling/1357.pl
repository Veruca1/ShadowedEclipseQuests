sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
            "You’ve come far, haven’t you? But distance is an illusion in the weave… and you are *still* only beginning.<br><br>" .
            "Grimling Forest—so many pass through its canopies, never once seeing *beneath* them. The Wars, the Shak Dratha, the Sanctus… distractions. Echoes. But *we* see the truth.<br><br>" .
            "The Umbral Chorus sings through the roots there. The Coven listens. And the Guide... watches.<br><br>" .
            "No longer will you seek keys like a desperate scavenger. Instead, you must gather <c \"#D08080\">minion essences</c> from the lesser filth and <c \"#C070B0\">miniature echoes</c> from the stronger ones. Each one is a whisper—a note in the symphony of corruption that clings to this forest.<br><br>" .
            "Bring them to your vessel. Let it *taste* their decay. Let it *refine* what you carry. Only then may you pierce the veils hiding the sanctum beyond.<br><br>" .
            "And if you find the Umbral Guide... do not chase. Do not plead. Just *listen*.<br><br>" .
            "There are patterns in blood. There is truth in rot.<br><br>" .
            "<c \"#8080C0\">The Chorus waits… and watches.</c>"
        );
        plugin::Whisper("If your curiosity lingers... I can offer you a path into a place untouched. Say [list zones]... or the name of the one that calls to you.");
    }
    elsif ($text =~ /list zones/i) {
        plugin::Whisper("The Chorus offers passage to these echoes of reality:");
        plugin::Whisper("  - " . quest::saylink("Grimling Forest", 1, "Grimling Forest (grimling)"));
        plugin::Whisper("  - " . quest::saylink("Scarlet Desert", 1, "Scarlet Desert (scarlet)"));
    }
    elsif ($text =~ /^(Grimling|Grimling Forest|grimling)$/i) {
        CreateCustomDZ("grimling", "Grimling Forest");
    }
    elsif ($text =~ /^(Scarlet|Scarlet Desert|scarlet)$/i) {
        CreateCustomDZ("scarlet", "Scarlet Desert");
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
    my $dz_duration = 14400; # 4 hours
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