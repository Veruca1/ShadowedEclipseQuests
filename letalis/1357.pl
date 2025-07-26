sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
            "You have come to *Mons Letalis*. The name, in the old tongue, means <c \"#FF8080\">'Lethal Mountain'</c>... and it is no metaphor.<br><br>" .
            "The stones here slice deeper than flesh. They pierce the weave. They *remember*.<br><br>" .
            "That tower you see—it was not built for worship, nor defense. It was prison and playground for a *banished mind*—a scholar of the Combine Empire, cast out for ambition too great even for them.<br><br>" .
            "He studied the Moon. He did not ask its permission.<br><br>" .
            "Now, only echoes remain. Failed trials. Twisted remains. A terrain reshaped by forgotten experiments.<br><br>" .
            "Even the Chorus and the Coven... they have forsaken this place. And yet something *waits*. Nestled in the ravines. *Watching.*<br><br>" .
            "You know the steps. You know what must be gathered, and what must be left behind.<br><br>" .
            "But listen well—many will tread these sands and see only silence. Few will uncover the hidden warriors of *Scarlet Desert*, of *Mons Letalis*, and of what lies ahead in *The Grey*.<br><br>" .
            "<c \"#8080C0\">The weave thins… but only for those who *look*.</c>"
        );
        plugin::Whisper("If your curiosity lingers... I can offer you a path into a place untouched. Say [list zones]... or the name of the one that calls to you.");
    }
    elsif ($text =~ /list zones/i) {
        plugin::Whisper("The Chorus offers passage to these echoes of reality:");
        plugin::Whisper("  - " . quest::saylink("Mons Letalis", 1, "Mons Letalis (letalis)"));
        plugin::Whisper("  - " . quest::saylink("The Grey", 1, "The Grey (thegrey)"));
    }
    elsif ($text =~ /^(Letalis|Mons Letalis|letalis)$/i) {
        CreateCustomDZ("letalis", "Mons Letalis");
    }
    elsif ($text =~ /^(The Grey|Grey|thegrey)$/i) {
        CreateCustomDZ("thegrey", "The Grey");
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