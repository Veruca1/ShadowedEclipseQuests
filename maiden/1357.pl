sub EVENT_SAY {
    my $maiden_link = quest::saylink("maiden", 1);
    my $akheva_link = quest::saylink("akheva", 1);

    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
        "<c \"#CCCCFF\">You stand where the moon once wept.</c><br><br>" .
        "<c \"#9999CC\">Maiden’s Eye</c> was once a sacred basin. The lunar tribes sent offerings here, seeking guidance from the stars.<br>" .
        "But the Choirs have fallen. Their voices clash, their minds broken or bound.<br><br>" .

        "Now only four remnants remain, fractured echoes of purpose:<br>" .
        "<c \"#CCAA88\">▪ Sanctum of Dust</c> – a monastery where Shadebound Monks chant madness into the wind.<br>" .
        "<c \"#CCAA88\">▪ Waning Crescent Bastion</c> – fortress of the Pale Matron’s zealots, knights who bleed silver.<br>" .
        "<c \"#CCAA88\">▪ The Forgotten Lyceum</c> – halls where knowledge festered and found teeth.<br>" .
        "<c \"#CCAA88\">▪ Bloodglass Watch</c> – an eye turned outward, now cracked and watching inward.<br><br>" .

        "Beneath it all, slumbers <c \"#CCCCFF\">The Eye</c>, an ancient construct that sees across time.<br>" .
        "Nyseria wishes to awaken it. We, the <c \"#9999CC\">Umbral Chorus</c>, must witness — and if needed, intervene.<br><br>" .

        "Deeper still lie the <c \"#CCCCFF\">Akheva ruins</c>, where the <c \"#FF9999\">Coven</c> stirs the past like coals in the dark.<br>" .
        "There they reshape what once was — forging the <c \"#FFCCCC\">Eclipse Mirror</c>, a rift to a timeline not yet lived.<br><br>" .

        "<c \"#AAAAFF\">The Chorus watches, even when the Eye is closed.</c>"
        );

        quest::whisper("Speak if you wish to tread these paths — say $maiden_link for the Eye’s surface, or $akheva_link for its depths.");
    }

    if ($text =~ /maiden/i) {
        my $group = $client->GetGroup();
        my $zone_id = "maiden";
        my $version = 1;
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        plugin::Whisper("Let the Eye judge you, traveler. May your steps be shadowed and sharp.");
        if ($group) {
            $client->SendToInstance("group", $zone_id, $version, $x, $y, $z, $h, "maiden", 14400);
        } else {
            $client->SendToInstance("solo", $zone_id, $version, $x, $y, $z, $h, "maiden", 14400);
        }
    }

    if ($text =~ /akheva/i) {
        my $group = $client->GetGroup();
        my $zone_id = "akheva";
        my $version = 0;
        my $x = 60;
        my $y = -1395;
        my $z = 23.06;
        my $h = 0;

        plugin::Whisper("Go then, to the stones that still speak. May Sel’Rheza veil your intentions.");
        if ($group) {
            $client->SendToInstance("group", $zone_id, $version, $x, $y, $z, $h, "akheva", 14400);
        } else {
            $client->SendToInstance("solo", $zone_id, $version, $x, $y, $z, $h, "akheva", 14400);
        }
    }
}