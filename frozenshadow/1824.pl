sub EVENT_SPAWN {
    # Set timers for checking buffs and HP
    quest::settimer("check_buffs", 1);
    quest::settimer("hp_check", 5);  # Check HP every 5 seconds

    # Apply Camera Effect
    $npc->CameraEffect(1000, 3);

    # Get all clients in the zone
    my @clients = $entity_list->GetClientList();

    # Define the text for the marquee
    my $text = "You feel a great sense of dread, as you hear a familiar unsettling cackle nearby";

    # Send the marquee message to each client in the zone
    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);  # Broadcasting to all players
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # When the NPC engages in combat
        quest::shout("You think you can escape me? Do you? You will pay for your insolence!");
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        # Cast the spell only if the buff is not already present
        $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);
    }

    if ($timer eq "hp_check") {
        if ($npc->GetHPRatio() <= 50) {
            quest::stoptimer("hp_check");
            quest::depop();
            quest::spawn2(1825, 0, 0, -415.38, 586.41, 22.25, 137.75);
	    quest::spawn2(1828, 0, 0, -362.44, 600.25, 23.83, 366.50);
	    quest::spawn2(1829, 0, 0, -370.47, 562.31, 23.83, 414.75);
        }
    }
}