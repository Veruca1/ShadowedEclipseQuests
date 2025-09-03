sub EVENT_SPAWN {
    return unless $npc;

    # --- Check if NPC 502004 already exists, if not, spawn it ---
    my $npc_check = $entity_list->GetNPCByNPCTypeID(502004);
    if (!$npc_check) {
        quest::spawn2(502004, 0, 0, 79.02, 534.05, 32.06, 382.00);
    }

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # Use plugin to check exclusion list
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    $npc->SetNPCFactionID(623);

    # --- Raid detection (6+ real clients, bots don’t count) ---
    my $client_count = 0;
    foreach my $c ($entity_list->GetClientList()) {
        $client_count++ if $c && $c->GetHP() > 0;
    }
    my $is_raid = ($client_count >= 6) ? 1 : 0;

    # --- Scaling stats based on raid presence ---
    my $ac        = $is_raid ? 20000 * 1.5 : 20000;
    my $hp        = $is_raid ? 6500000 * 1.5 : 6500000;   # 6.5M group / 9.75M raid
    my $regen     = $is_raid ? 800 * 1.5 : 800;
    my $min_hit   = $is_raid ? 24000 * 1.5 : 24000;
    my $max_hit   = $is_raid ? 40000 * 1.5 : 40000;
    my $atk       = $is_raid ? 2500 * 1.5 : 2500;
    my $accuracy  = $is_raid ? 1800 * 1.5 : 1800;

    $npc->ModifyNPCStat("level", 62);
    $npc->ModifyNPCStat("ac", int($ac));
    $npc->ModifyNPCStat("max_hp", int($hp));
    $npc->ModifyNPCStat("hp_regen", int($regen));
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", int($min_hit));
    $npc->ModifyNPCStat("max_hit", int($max_hit));
    $npc->ModifyNPCStat("atk", int($atk));
    $npc->ModifyNPCStat("accuracy", int($accuracy));
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", $is_raid ? 8 : 10);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", $is_raid ? 30 : 26); # 26 group / 30 raid
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # Attributes
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    # Resists
    $npc->ModifyNPCStat("mr", 300);
    $npc->ModifyNPCStat("fr", 300);
    $npc->ModifyNPCStat("cr", 300);
    $npc->ModifyNPCStat("pr", 300);
    $npc->ModifyNPCStat("dr", 300);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    # Vision / mechanics
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # Special abilities
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10^14,1");

    # --- Reset HP after scaling ---
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}