sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID();

    # Exclusion list: skip certain NPC IDs and pets
    my %exclusion_list = (
        857 => 1,
        681 => 1,
        679 => 1,
        776 => 1,
        map { $_ => 1 } (2000000..2000017)
    );
    return if exists $exclusion_list{$npc_id};
    return if $npc->IsPet();

    my $is_boss = ($raw_name =~ /^#/ || $npc_id == 1919) ? 1 : 0;

    $npc->SetNPCFactionID(623);

    my $wrath_triggered = 0;

    if ($is_boss) {
        $npc->ModifyNPCStat("level", 63);
        $npc->ModifyNPCStat("ac", 20000);
        $npc->ModifyNPCStat("max_hp", 2000000);
        $npc->ModifyNPCStat("hp_regen", 1000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 8000);
        $npc->ModifyNPCStat("max_hit", 11500);
        $npc->ModifyNPCStat("atk", 1400);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 90);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);

        $npc->ModifyNPCStat("str", 1200);
        $npc->ModifyNPCStat("sta", 1200);
        $npc->ModifyNPCStat("agi", 1200);
        $npc->ModifyNPCStat("dex", 1200);
        $npc->ModifyNPCStat("wis", 1200);
        $npc->ModifyNPCStat("int", 1200);
        $npc->ModifyNPCStat("cha", 1000);
    
        $npc->ModifyNPCStat("mr", 500);
        $npc->ModifyNPCStat("fr", 500);
        $npc->ModifyNPCStat("cr", 500);
        $npc->ModifyNPCStat("pr", 500);
        $npc->ModifyNPCStat("dr", 500);
        $npc->ModifyNPCStat("corruption_resist", 500);
        $npc->ModifyNPCStat("physical_resist", 1000);
       
        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("aggro", 40);
        $npc->ModifyNPCStat("assist", 1);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1");

        quest::setnexthpevent(50);
    }
        else {
        $npc->ModifyNPCStat("level", 61);
        $npc->ModifyNPCStat("ac", 18000);
        $npc->ModifyNPCStat("max_hp", 1500000);
        $npc->ModifyNPCStat("hp_regen", 800);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 6000);
        $npc->ModifyNPCStat("max_hit", 9000);
        $npc->ModifyNPCStat("atk", 1200);
        $npc->ModifyNPCStat("accuracy", 1800);
        $npc->ModifyNPCStat("avoidance", 80);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 80);
        $npc->ModifyNPCStat("attack_count", 100);

        $npc->ModifyNPCStat("str", 1000);
        $npc->ModifyNPCStat("sta", 1000);
        $npc->ModifyNPCStat("agi", 1000);
        $npc->ModifyNPCStat("dex", 1000);
        $npc->ModifyNPCStat("wis", 1000);
        $npc->ModifyNPCStat("int", 1000);
        $npc->ModifyNPCStat("cha", 800);

        $npc->ModifyNPCStat("mr", 300);
        $npc->ModifyNPCStat("fr", 300);
        $npc->ModifyNPCStat("cr", 300);
        $npc->ModifyNPCStat("pr", 300);
        $npc->ModifyNPCStat("dr", 300);
        $npc->ModifyNPCStat("corruption_resist", 300);
        $npc->ModifyNPCStat("physical_resist", 800);

        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("aggro", 25);
        $npc->ModifyNPCStat("assist", 1);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1");
    }

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_HP {
    return unless $npc;
    return unless $is_boss;

    if ($hpevent == 50) {
        # Check if NPC has debuff spell 40745 active
        if ($npc->FindBuff(40745)) {
            plugin::Debug("Boss has debuff 40745 mark of silence, skipping help call.");
            return;
        }

        quest::shout("Surrounding minions of the cavern, arise and assist me!");
        my $top = $npc->GetHateTop();
        return unless $top;

        my @npcs = $entity_list->GetNPCList();
        return unless @npcs;

        foreach my $mob (@npcs) {
            next unless $mob && $mob->GetID() != $npc->GetID();
            my $dist = $npc->CalculateDistance($mob);
            $mob->AddToHateList($top, 1) if defined $dist && $dist <= 300;
        }
    }
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        quest::settimer("life_drain", 5) if $is_boss;
    } else {
        quest::stoptimer("life_drain") if $is_boss;
        quest::settimer("reset_hp_event", 50) if $is_boss;
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "life_drain" && $is_boss) {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $radius = 50;
        my $drain_damage = 6000;

        foreach my $client ($entity_list->GetClientList()) {
            next unless $client;
            my $dist = $client->CalculateDistance($x, $y, $z);
            $client->Damage($npc, $drain_damage, 0, 1, false) if $dist <= $radius;
        }

        foreach my $bot ($entity_list->GetBotList()) {
            next unless $bot;
            my $dist = $bot->CalculateDistance($x, $y, $z);
            $bot->Damage($npc, $drain_damage, 0, 1, false) if $dist <= $radius;
        }
    }
}