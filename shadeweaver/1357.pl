sub EVENT_SAY {
    my $instance_link = quest::saylink("instance", 1);  # Clickable 'instance'

    if ($text =~ /hail/i) {
        quest::summonitem(33202);  # Shadeweaver's Kit
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
        "When you have gathered *twenty of each*, place them into this kit. It will form a <c \"#E0E070\">Symbol of the Shadeweaver</c>.<br><br>" .
        "You may also come across the <c \"#B070C0\">Loda Kai</c> in your travels. They are... restless. Their clan is known to challenge one another for dominance—hunting conquests, they call them. If you engage them, you may uncover more about their strange rites and the trials they impose upon each other. Curiosity, after all, is rarely without reward.<br><br>" .
        "<c \"#8080C0\">The Chorus waits… and watches.</c>"
        );
        quest::whisper("If you would like your own private version of Shadeweaver's Thicket, just say $instance_link.");
    }

    if ($text =~ /instance/i) {
        my $group = $client->GetGroup();
        my $zone_id = "shadeweaver";
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $npc_h = $npc->GetHeading();

        plugin::Whisper("Good luck adventurer!");

        if ($group) {
            $client->SendToInstance("group", $zone_id, 0, $npc_x, $npc_y, $npc_z, $npc_h, "shadeweaver", 14400);
        } else {
            $client->SendToInstance("solo", $zone_id, 0, $npc_x, $npc_y, $npc_z, $npc_h, "shadeweaver", 14400);
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