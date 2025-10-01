my $scaled_spawn = 0;  # block double scaling

sub EVENT_SPAWN {
    return unless $npc;
    $npc->SetNPCFactionID(623);

    # === Boss baseline stats ===
    $npc->ModifyNPCStat("level",     65);
    $npc->ModifyNPCStat("ac",        30000);
    $npc->ModifyNPCStat("max_hp",    30000000);
    $npc->ModifyNPCStat("hp_regen",  3000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit",   50000);
    $npc->ModifyNPCStat("max_hit",   75000);
    $npc->ModifyNPCStat("atk",       2500);
    $npc->ModifyNPCStat("accuracy",  2000);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 33);

    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 90);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1200);
    $npc->ModifyNPCStat("sta", 1200);
    $npc->ModifyNPCStat("agi", 1200);
    $npc->ModifyNPCStat("dex", 1200);
    $npc->ModifyNPCStat("wis", 1200);
    $npc->ModifyNPCStat("int", 1200);
    $npc->ModifyNPCStat("cha", 1000);

    $npc->ModifyNPCStat("mr", 400);
    $npc->ModifyNPCStat("fr", 400);
    $npc->ModifyNPCStat("cr", 400);
    $npc->ModifyNPCStat("pr", 400);
    $npc->ModifyNPCStat("dr", 400);
    $npc->ModifyNPCStat("corruption_resist", 500);
    $npc->ModifyNPCStat("physical_resist",   1000);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8^13,1^14,1^15,1^17,1^21,1");

    # Scale for raid/group size
    plugin::RaidScaling($entity_list, $npc);
    $scaled_spawn = 1;

    # Ensure HP is set after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    my $text = "Only eyes like yours can see ghosts, ghosts like me.";

    my @clients = $entity_list->GetClientList();
    foreach my $client (@clients) {
        next unless $client;
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
    }
}