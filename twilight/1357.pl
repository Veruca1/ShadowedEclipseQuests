sub EVENT_SAY {
    my $twilight_link = quest::saylink("twilight", 1);
    my $fungusgrove_link = quest::saylink("fungusgrove", 1);

    if ($text =~ /hail/i) {
         quest::popup(
    "The Envoy of Sel'Rheza",
    "Listen well, wanderer — the sea is not silent.<br><br>" .
    "The <c \"#9999CC\">Twilight Sea</c> shimmers with hidden threads: islands adrift with shadows, tribes that speak in riddles, and creatures born of the dark tide.<br><br>" .
    "Elementals stir among the coral and rock, shaped by a magician who delves too deep into the sea’s pulse. His tower rises against the dusk, a beacon of forbidden craft. Rumors whisper he weaves a <c \"#C0A0FF\">legendary elemental</c>, bound by keys yet scattered.<br><br>" .
    "Lesser shadows gather at the water’s edge, tribal sentinels guard their secrets, and the currents carry whispers of what lies below.<br><br>" .
    "Should you wish to breach the Grove of Fungus — that hidden cradle far beneath — you must find the fragments that bind its gate. Construct the key. Return it to me, the Envoy, and you may walk where few dare to tread.<br><br>" .
    "<c \"#AAAAFF\">Sel'Rheza watches where the tide turns darkest.</c>"
        );

        quest::whisper(
            "Speak your wish, wanderer. Utter $twilight_link to tread the sea’s hush, or $fungusgrove_link to walk Fungus Grove’s ruin. " .
            "The Umbral Chorus shall weigh your passage."
        );

        # Depop all other NPCs in version 0, except self
        my $version = $zone->GetInstanceVersion();
        if ($version == 0) {
            my @npcs = $entity_list->GetNPCList();
            foreach my $mob (@npcs) {
                next unless $mob;
                next if $mob->GetNPCTypeID() == 1357; # Replace with your actual NPC ID
                $mob->Depop();
            }
        }
    }

    if ($text =~ /twilight/i) {
    my $group = $client->GetGroup();
    my $zone_id = "twilight";
    my $version = 0;

    # Updated safe loc for The Twilight Sea
    my $x = -1945.43;
    my $y = -108.53;
    my $z = 96.12;
    my $h = 129.00;

    plugin::Whisper("Let the northern winds carry you. May Sel'Rheza weigh your steps across the sea’s hush.");
    if ($group) {
        $client->SendToInstance("group", $zone_id, $version, $x, $y, $z, $h, "twilight", 14400);
    } else {
        $client->SendToInstance("solo", $zone_id, $version, $x, $y, $z, $h, "twilight", 14400);
    }
}

    if ($text =~ /fungusgrove/i) {
        my $group = $client->GetGroup();
        my $zone_id = "fungusgrove";
        my $version = 0; # force version 0

        # Hardcoded safe loc for Fungus Grove (adjust if needed)
        my $x = -1005.00;
        my $y = -2088.08;
        my $z = -307.93;
        my $h = 0.0;

        plugin::Whisper("Descend, then, into marble’s last dream. The Chorus shall listen as the stone remembers.");
        if ($group) {
            $client->SendToInstance("group", $zone_id, $version, $x, $y, $z, $h, "fungusgrove", 14400);
        } else {
            $client->SendToInstance("solo", $zone_id, $version, $x, $y, $z, $h, "fungusgrove", 14400);
        }
    }

    sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 42685 => 1)) {
        plugin::Whisper("The Envoy studies your key, tracing its edges with a fingertip. 'Well done, wanderer. The grove awaits, but this path forks further still.'");

        # Do NOT return item 42685 — instead give back 42686 and 42687
        quest::summonitem(42686); # The Key to Fungus Grove (upgraded)
        quest::summonitem(42687); # A mysterious key
    }

    plugin::return_items(\%itemcount); # Return any other hand-ins
}

}