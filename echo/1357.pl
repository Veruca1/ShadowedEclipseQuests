sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
        "Echo Caverns... the name does it no justice. This place is <c \"#B070C0\">alive</c> with resonance, with memory. Footsteps do not fade here—they repeat, like fractured truths caught in stone.<br><br>" .
        "The <c \"#9999CC\">Umbral Chorus</c> once sent only shadows to walk these halls. Now I come in flesh, in faith, in service of <c \"#C080C0\">Sel’Rheza</c>. The Goddess above watches, ever uncertain of our purpose. <c \"#990066\">We do not challenge her</c>—we exist within her silence.<br><br>" .
        "This place is vast. Deceptively so. If you would reach the truth, you must explore it in full. <c \"#FF9999\">Seek the named</c>, yes, but <c \"#CCCCCC\">do not dismiss the minions</c>—those who linger near the entrance may yet carry pieces of the greater weave, much like the Paludal ones before them.<br><br>" .
        "I know little of what lies ahead, but I have felt the pull... a sense that <c \"#9999FF\">The Deep</c> awaits beyond. Hidden paths, locked by confusion or by choice, may only open when you’ve seen all Echo has to offer.<br><br>" .
        "You are not here by mistake. The <c \"#8080C0\">Coven of the Shadowed Eclipse</c> watches, and their patience is long... but not infinite. Proceed with care, and perhaps Sel’Rheza herself will grant you a glimpse of what sleeps beneath.<br><br>" .
        "<c \"#8080C0\">The Chorus waits… and watches.</c>"
        );
        plugin::Whisper("If your path is unclear, speak and I shall open the way. Say [list zones] to hear the echoes that await... or name the one that calls to you.");
    }

    elsif ($text =~ /list zones/i) {
        plugin::Whisper("The echoes stir in these realms:");
        plugin::Whisper("  - " . quest::saylink("Echo Caverns", 1, "Echo Caverns (echo)"));
        plugin::Whisper("  - " . quest::saylink("The Deep", 1, "The Deep (thedeep)"));
    }

    elsif ($text =~ /^(Echo Caverns|echo)$/i) {
        CreateCustomDZ("echo", "Echo Caverns");
    }

    elsif ($text =~ /^(The Deep|thedeep)$/i) {
        CreateCustomDZ("thedeep", "The Deep");
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

# DZ creation helper
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