my $is_boss = 0;

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # Exclusion list check
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Boss flag
    $is_boss = ($raw_name =~ /^#/) ? 1 : 0;
    $npc->SetNPCFactionID(623);

    if ($is_boss) {
        # --- Boss baseline stats ---
        $npc->ModifyNPCStat("level", 65);
        $npc->ModifyNPCStat("ac", 30000);
        $npc->ModifyNPCStat("max_hp", 30000000);
        $npc->ModifyNPCStat("hp_regen", 3000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 55000);
        $npc->ModifyNPCStat("max_hit", 75000);
        $npc->ModifyNPCStat("atk", 2500);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 50);
        $npc->ModifyNPCStat("attack_delay", 6);
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
        $npc->ModifyNPCStat("physical_resist", 1000);

        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat(
            "special_abilities",
            "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1"
        );

        # Now apply scaling on top of baseline
        plugin::RaidScaling($entity_list, $npc);

        # Keep checking every 10s in case group makeup changes
        quest::settimer("check_combat_scaling", 10);
    }

    # Full heal
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "check_combat_scaling" && $is_boss) {
        plugin::RaidScaling($entity_list, $npc);
    }
    elsif ($timer eq "spider") {
        quest::spawn2(205161, 0, 0, 108, -3384, -220, 357);
        quest::spawn2(205161, 0, 0, 108, -3384, -220, 357);
        quest::stoptimer("spider");
        quest::settimer("spiders", 20);
    }
    elsif ($timer eq "spiders") {
        quest::spawn2(205161, 0, 0, 108, -3384, -220, 357);
        quest::spawn2(205161, 0, 0, 108, -3384, -220, 357);
        quest::stoptimer("spiders");
        quest::settimer("spiders", 20);
    }
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1 && $is_boss) {
        # Re-run scaling when combat starts
        plugin::RaidScaling($entity_list, $npc);

        quest::settimer("spider", 2);
    } else {
        quest::stoptimer("spider");
        quest::stoptimer("spiders");
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::depopall(205161);
    quest::depopall(205162);
}