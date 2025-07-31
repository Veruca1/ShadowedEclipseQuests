sub EVENT_SAY {
    my $tenebrous_link = quest::saylink("tenebrous", 1);
    my $katta_link = quest::saylink("katta", 1);

    if ($text =~ /hail/i) {
        quest::popup(
            "Envoy of Sel'Rheza",
            "<c \"#CCCCFF\">The northern skies stir with unseen wings.</c><br><br>" .
            "In the <c \"#9999CC\">Tenebrous Mountains</c>, shadows gather where stone scrapes the stars.<br>" .
            "Paths twist through thorn and ruin — each echo feeds the Umbral Chorus.<br><br>" .
            "Trash wander where brambles choke the old roads. Within the peaks, lesser lords stand guard, voices bound to a sleeping crown.<br>" .
            "Above all, the castle’s heart waits for those with strength to silence its watchmen.<br><br>" .
            "Yet stone alone will not break the old blood. Spell and steel, sundered pieces, lie scattered — found in caves, heights, and forgotten chambers.<br>" .
            "Claim them if you would see shadow bleed.<br><br>" .
            "Above, the northern winds whisper secrets that cling to cliff and sky. The patient may find more than echoes there.<br><br>" .
            "Should you bind relic and rite, the mountain may yield its mark — a trophy of the hunt.<br>" .
            "And far below, <c \"#9999CC\">Katta</c> dreams in marble decay, its halls burdened with secrets older than the stone.<br>" .
            "<c \"#AAAAFF\">Sel'Rheza smiles where shadows linger longest.</c>"
        );

        quest::whisper(
            "Speak your wish, wanderer. Utter $tenebrous_link to tread the mountain’s hush, or $katta_link to walk Katta’s ruin. " .
            "The Umbral Chorus shall weigh your passage."
        );
    }

    if ($text =~ /tenebrous/i) {
        my $group = $client->GetGroup();
        my $zone_id = "tenebrous";
        my $version = 0;

        my $x = 1823.30;
        my $y = 54.62;
        my $z = -35.69;
        my $h = 366.25;

        plugin::Whisper("Let the northern winds carry you. May Sel'Rheza weigh your steps in the mountain’s shadow.");
        if ($group) {
            $client->SendToInstance("group", $zone_id, $version, $x, $y, $z, $h, "tenebrous", 14400);
        } else {
            $client->SendToInstance("solo", $zone_id, $version, $x, $y, $z, $h, "tenebrous", 14400);
        }
    }

    if ($text =~ /katta/i) {
        my $group = $client->GetGroup();
        my $zone_id = "katta";
        my $version = 0;
        my $x = -545.0;
        my $y = 645.0;
        my $z = 3.06;
        my $h = 259.25;

        plugin::Whisper("Descend, then, into marble’s last dream. The Chorus shall listen as the stone remembers.");
        if ($group) {
            $client->SendToInstance("group", $zone_id, $version, $x, $y, $z, $h, "katta", 14400);
        } else {
            $client->SendToInstance("solo", $zone_id, $version, $x, $y, $z, $h, "katta", 14400);
        }
    }
}