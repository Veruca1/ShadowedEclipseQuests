sub EVENT_SAY {
    my $instance_link = quest::saylink("instance", 1);  # Clickable 'instance'

    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
        "Ah... so you *descend* as we once did. <c \"#B070C0\">Paludal</c>... endless and echoing. The caverns sprawl like veins across the corpse of the moon, a perfect cradle for secrets best left untouched.<br><br>" .
        "The <c \"#9999CC\">Umbral Chorus</c> guided my steps here, in service of <c \"#C080C0\">Sel’Rheza</c>. Her whispers still linger in the dark between the dripping stone. I do not question the path. I only sing where I am told to sing.<br><br>" .
        "You’ve come here because of the <c \"#E0E070\">Shard</c>, yes? The same one that drew us to <c \"#CC00CC\">The Void</c>. It hums more urgently now. That is no accident. These tunnels are not merely a passage—they are a crucible.<br><br>" .
        "The Goddess of Shadows watches from above. Her gaze is <c \"#990066\">unforgiving</c>, even to those of us who chant the names of her chosen. This place... it tests your worth.<br><br>" .
        "You must traverse every twist, every bend. Do not merely pursue the <c \"#FF9999\">named</c>. They are vital, yes—but even the lowliest of the <c \"#CCCCCC\">minions</c> at the mouth of this place may hold fragments of truth, just as the <c \"#B070C0\">Loda Kai</c> did before them. <br><br>" .
        "I know little of what lies deeper. But I have heard... <c \"#9966FF\">something waits at the top</c>. A convergence, perhaps. A clarity, if you endure.<br><br>" .
        "Go. Learn what I cannot. The <c \"#8080C0\">Coven of the Shadowed Eclipse</c> may soon judge your worth, and their favor is a rare thing indeed.<br><br>" .
        "<c \"#8080C0\">The Chorus waits… and watches.</c>"
        );
        quest::whisper("If you would like your own private version of Paludal Caverns, just say $instance_link.");
    }

    if ($text =~ /instance/i) {
        my $group = $client->GetGroup();
        my $zone_id = "paludal";
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $npc_h = $npc->GetHeading();

        plugin::Whisper("Good luck, adventurer. May Sel’Rheza's illusions guide and shield you.");

        if ($group) {
            $client->SendToInstance("group", $zone_id, 0, $npc_x, $npc_y, $npc_z, $npc_h, "paludal", 14400);
        } else {
            $client->SendToInstance("solo", $zone_id, 0, $npc_x, $npc_y, $npc_z, $npc_h, "paludal", 14400);
        }
    }
}