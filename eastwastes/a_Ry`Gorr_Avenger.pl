sub EVENT_SPAWN {
    return unless $npc;

    # === Trash Baseline Stats (from default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 55);
    $npc->ModifyNPCStat("ac", 9500);
    $npc->ModifyNPCStat("max_hp", 200000);
    $npc->ModifyNPCStat("hp_regen", 700);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 3600);
    $npc->ModifyNPCStat("max_hit", 4800);
    $npc->ModifyNPCStat("atk", 850);
    $npc->ModifyNPCStat("accuracy", 850);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 7);
    $npc->ModifyNPCStat("heroic_strikethrough", 4);
    $npc->ModifyNPCStat("slow_mitigation", 60);
    $npc->ModifyNPCStat("aggro", 45);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 750);
    $npc->ModifyNPCStat("sta", 750);
    $npc->ModifyNPCStat("agi", 750);
    $npc->ModifyNPCStat("dex", 750);
    $npc->ModifyNPCStat("wis", 750);
    $npc->ModifyNPCStat("int", 750);
    $npc->ModifyNPCStat("cha", 550);

    $npc->ModifyNPCStat("mr", 160);
    $npc->ModifyNPCStat("fr", 160);
    $npc->ModifyNPCStat("cr", 160);
    $npc->ModifyNPCStat("pr", 160);
    $npc->ModifyNPCStat("dr", 160);
    $npc->ModifyNPCStat("corruption_resist", 130);
    $npc->ModifyNPCStat("physical_resist", 320);

    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1");
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("runspeed", 2);

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Add all players in the zone to the hate list ===
    my @players = $entity_list->GetClientList();
    foreach my $player (@players) {
        next unless $player;
        $npc->AddToHateList($player, 1, 1000);
    }
}