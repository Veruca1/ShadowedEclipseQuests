sub EVENT_SPAWN {
    return unless $npc;

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
    my $ac        = $is_raid ? 12000 * 1.5 : 12000;
    my $hp        = $is_raid ? 1500000 * 1.5 : 1500000;   # 1.5M group / 2.25M raid
    my $regen     = $is_raid ? 400 * 1.5 : 400;
    my $min_hit   = $is_raid ? 12000 * 1.5 : 12000;
    my $max_hit   = $is_raid ? 20000 * 1.5 : 20000;
    my $atk       = $is_raid ? 1800 * 1.5 : 1800;
    my $accuracy  = $is_raid ? 1400 * 1.5 : 1400;

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
    $npc->ModifyNPCStat("slow_mitigation", 70);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", $is_raid ? 30 : 26);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # Attributes
    $npc->ModifyNPCStat("str", 800);
    $npc->ModifyNPCStat("sta", 800);
    $npc->ModifyNPCStat("agi", 800);
    $npc->ModifyNPCStat("dex", 800);
    $npc->ModifyNPCStat("wis", 800);
    $npc->ModifyNPCStat("int", 800);
    $npc->ModifyNPCStat("cha", 600);

    # Resists
    $npc->ModifyNPCStat("mr", 250);
    $npc->ModifyNPCStat("fr", 250);
    $npc->ModifyNPCStat("cr", 250);
    $npc->ModifyNPCStat("pr", 250);
    $npc->ModifyNPCStat("dr", 250);
    $npc->ModifyNPCStat("corruption_resist", 200);
    $npc->ModifyNPCStat("physical_resist", 500);

    # Vision / mechanics
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # Special abilities
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8^14,1");

    # --- Reset HP after scaling ---
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Each elemental death gives you more time, hurry stop him!");
    # resets timer
    quest::signalwith(2194, 101);
}