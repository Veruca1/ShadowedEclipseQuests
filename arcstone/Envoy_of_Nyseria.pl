my $reliquary_id = 60461;
my $reliquary_required = 20;

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Nyseria",
            "Ah... the breath of fate brushes close again.<br><br>"
            . "Sel'Rheza has fallen. The whispers of the Ssraeshza halls echo hollow now, but the shadows... the shadows have only grown deeper.<br><br>"
            . "Where once I served the dreams of a would-be goddess, now I kneel at the obsidian veil of Nyseria—the true face behind the eclipse.<br><br>"
            . "Within the bowels of Ssra Temple, truths were unearthed: broken seals, tortured stone, and the shimmer of Luclin's fractured gaze. You saw it, didn’t you? The Image? It watched back.<br><br>"
            . "Now, in the time of influence—what you call the Planes of Power—I am reborn. Nyseria’s coven rises. The Shadowed Eclipse stirs, and with it, destiny falters.<br><br>"
            . "Should you wish the blessing of the veiled gods, you must bring forth offerings. Twenty shall be required—relics drawn from the hands of those who defy the eclipse.<br><br>"
            . "Seek and deliver twenty <c \"#E0E070\">Twilight Reliquaries</c>. Only then will your path darken... and deepen.<br><br>"
            . "<c \"#8080C0\">The Eye sleeps. But not forever.</c>"
        );
        plugin::Whisper("The weave changes. Speak the names of the realms you seek—if echoes still bind them, I may open the path.");
        plugin::Whisper("  - " . quest::saylink("Plane of Disease", 1, "Plane of Disease (podisease)"));
        plugin::Whisper("  - " . quest::saylink("Crypt of Decay", 1, "Crypt of Decay (codecay)"));
    }
    elsif ($text =~ /list zones/i) {
        plugin::Whisper("The Eclipse reveals remnants of fading worlds:");
        plugin::Whisper("  - " . quest::saylink("Plane of Disease", 1, "Plane of Disease (podisease)"));
        plugin::Whisper("  - " . quest::saylink("Crypt of Decay", 1, "Crypt of Decay (codecay)"));
    }
    elsif ($text =~ /^(Plane of Disease|podisease)$/i) {
        CreateCustomDZ("podisease", "Plane of Disease");
    }
    elsif ($text =~ /^(Crypt of Decay|codecay)$/i) {
        CreateCustomDZ("codecay", "Crypt of Decay");
    }
    elsif ($text =~ /ready/i) {
        my $dz = $client->GetExpedition();
        if ($dz) {
            my $zone_short = $dz->GetZoneName();
            plugin::Whisper("The threads draw inward. You are bound for: $zone_short.");
            $client->MovePCDynamicZone($zone_short);
        } else {
            plugin::Whisper("No tether holds you. Speak again when your steps are chosen.");
        }
    }
}

sub EVENT_ITEM {
    my $key                = "twilight_reliquary_total";
    my $reliquary_id       = 60461;
    my $reliquary_required = 20;

    my $handin  = $itemcount{$reliquary_id} || 0;
    my $current = quest::get_data($key) || 0;

    if ($handin > 0) {
        quest::removeitem($reliquary_id, $handin);

        my $new_total = $current + $handin;
        quest::set_data($key, $new_total);

        if ($new_total >= $reliquary_required) {
            plugin::Whisper("The final seal breaks. The Eclipse unfolds...");
            quest::worldwidecastspell(12345);  # adjust spell ID as needed
            ## Server‑wide marquee:
            quest::worldwidemarquee(15, 510, 1, 1, 5000,
                "The Shadowed Eclipse stirs... Nyseria’s gaze falls across the land.");
            quest::delete_data($key);
        } else {
            #quest::ze(15, "The Envoy murmurs from beyond the veil: '$new_total of $reliquary_required relics bleed into the shadow... the convergence draws near.'");
        }
    } else {
        plugin::Whisper("These are not the offerings Nyseria seeks.");
    }
}

# Dynamic Zone (DZ) creation helper function
sub CreateCustomDZ {
    my ($shortname, $fullname) = @_;
    my $dz_duration = 43200; # 12 hours duration
    my $min_players = 1;
    my $max_players = 6;
    my $expedition_name = "DZ - $fullname";

    my $dz = $client->CreateExpedition($shortname, 0, $dz_duration, $expedition_name, $min_players, $max_players);

    if ($dz) {
        plugin::Whisper("A shard of '$fullname' is now accessible. Say [" . quest::saylink("ready", 1, "ready") . "] when prepared.");
    } else {
        plugin::Whisper("The shard remains closed. Try again later or consult the Eclipse.");
    }
}