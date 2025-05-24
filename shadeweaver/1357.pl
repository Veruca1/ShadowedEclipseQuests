sub EVENT_SAY {
    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
            "Ah, another child of curiosity... You hear them, don’t you? The whispers in the weave, the lullaby of the Umbral Chorus...<br><br>" .
            "We do not ask for loyalty. We awaken it. We sing to the pieces of you you’ve long buried.<br><br>" .
            "Shadeweaver’s Thicket stretches before you—wild, untamed, and full of *truths* waiting to be found.<br><br>" .
            "If you wish to understand, to *belong*, then begin by unraveling its song. There are five echoes in the thicket:<br><br>" .
            "<c \"#C08040\">- The native beasts</c><br>" .
            "<c \"#C0A060\">- The native residents</c><br>" .
            "<c \"#A0C070\">- The native insects</c><br>" .
            "<c \"#9090B0\">- The risen dead</c><br>" .
            "<c \"#C05050\">- The band of thieves</c><br><br>" .
            "Each will leave behind something—tokens of their nature. Seek them. Claim them.<br><br>" .
            "When you have gathered *ten of a single type*, place them into your <c \"#E0E070\">tier vessel</c> and combine them. It will yield a <c \"#E0E070\">Large Echo</c>—a stronger remnant of that kind.<br><br>" .
            "Do this *twice for each of the five types*—you will need *two Large Echoes per type*.<br><br>" .
            "When you hold *two Large Echoes of each of the five echoes*, place them all into your <c \"#E0E070\">tier vessel</c> and combine them. It will form a <c \"#E0E070\">Symbol of the Shadeweaver</c>.<br><br>" .
            "You may also come across the <c \"#B070C0\">Loda Kai</c> in your travels. They are... restless. Their clan is known to challenge one another for dominance—hunting conquests, they call them. If you engage them, you may uncover more about their strange rites and the trials they impose upon each other. Curiosity, after all, is rarely without reward.<br><br>" .
            "<c \"#8080C0\">The Chorus waits… and watches.</c>"
        );
        plugin::Whisper("If your curiosity lingers... I can offer you a path into a place untouched. Say [list zones]... or the name of the one that calls to you.");
    }
    elsif ($text =~ /list zones/i) {
        plugin::Whisper("The Chorus offers passage to these echoes of reality:");
        plugin::Whisper("  - " . quest::saylink("Shadeweaver's Thicket", 1, "Shadeweaver's Thicket (shadeweaver)"));
        plugin::Whisper("  - " . quest::saylink("Paludal Caverns", 1, "Paludal Caverns (paludal)"));
    }
    elsif ($text =~ /^(Shadeweaver|Shadeweaver's Thicket|shadeweaver)$/i) {
        CreateCustomDZ("shadeweaver", "Shadeweaver's Thicket");
    }
    elsif ($text =~ /^(Paludal|Paludal Caverns|paludal)$/i) {
        CreateCustomDZ("paludal", "Paludal Caverns");
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

sub EVENT_ITEM {
    if ($itemcount{33200} > 0) {
        quest::whisper("Ah... what a great and powerful find this is. The Symbol of the Shadeweaver... A clear representation of the zone's influence. It hums with power, yet... it is cold. Far too cold for one so tough as you. Perhaps it needs to be infused with a great flame.");
        quest::summonitem(33201);  # Enhanced Symbol
        quest::whisper("Take this to the entranced Firefall Seer to the north. Only then will it become clear what to do next.");
        quest::summonitem(33200);  # Return the original symbol
    }
}

# Dynamic Zone (DZ) creation helper function
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