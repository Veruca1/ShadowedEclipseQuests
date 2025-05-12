sub EVENT_SAY {
    my $instance_link = quest::saylink("instance", 1);  # Clickable 'instance'

    if ($text =~ /hail/i) {
        quest::popup("The Envoy of Sel'Rheza",
        "Echo Caverns... the name does it no justice. This place is <c \"#B070C0\">alive</c> with resonance, with memory. Footsteps do not fade here—they repeat, like fractured truths caught in stone.<br><br>" .
        "The <c \"#9999CC\">Umbral Chorus</c> once sent only shadows to walk these halls. Now I come in flesh, in faith, in service of <c \"#C080C0\">Sel’Rheza</c>. The Goddess above watches, ever uncertain of our purpose. <c \"#990066\">We do not challenge her</c>—we exist within her silence.<br><br>" .
        "This place is vast. Deceptively so. If you would reach the truth, you must explore it in full. <c \"#FF9999\">Seek the named</c>, yes, but <c \"#CCCCCC\">do not dismiss the minions</c>—those who linger near the entrance may yet carry pieces of the greater weave, much like the Paludal ones before them.<br><br>" .
        "I know little of what lies ahead, but I have felt the pull... a sense that <c \"#9999FF\">The Deep</c> awaits beyond. Hidden paths, locked by confusion or by choice, may only open when you’ve seen all Echo has to offer.<br><br>" .
        "You are not here by mistake. The <c \"#8080C0\">Coven of the Shadowed Eclipse</c> watches, and their patience is long... but not infinite. Proceed with care, and perhaps Sel’Rheza herself will grant you a glimpse of what sleeps beneath.<br><br>" .
        "<c \"#8080C0\">The Chorus waits… and watches.</c>"
        );
        quest::whisper("If you would like your own private version of Echo Caverns, just say $instance_link.");
    }

    if ($text =~ /instance/i) {
        my $group = $client->GetGroup();
        my $zone_id = "echo";
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $npc_h = $npc->GetHeading();

        plugin::Whisper("Let the echoes guide you. May Sel’Rheza illuminate the false paths and cloak you from what follows.");

        if ($group) {
            $client->SendToInstance("group", $zone_id, 0, $npc_x, $npc_y, $npc_z, $npc_h, "echo", 14400);
        } else {
            $client->SendToInstance("solo", $zone_id, 0, $npc_x, $npc_y, $npc_z, $npc_h, "echo", 14400);
        }
    }
}