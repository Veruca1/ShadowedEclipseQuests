sub EVENT_SPAWN {
    return unless $npc;

    my $npc_id = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # === Boss Stats ===
    $npc->SetNPCFactionID(623);

    $npc->ModifyNPCStat("level", 70);
    $npc->ModifyNPCStat("ac", 30000);
    $npc->ModifyNPCStat("max_hp", 300000000);
    $npc->ModifyNPCStat("hp_regen", 3000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 65000);
    $npc->ModifyNPCStat("max_hit", 115000);
    $npc->ModifyNPCStat("atk", 2500);
    $npc->ModifyNPCStat("accuracy", 2000);
    $npc->ModifyNPCStat("avoidance", 75);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 36);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 90);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    # === Attributes ===
    $npc->ModifyNPCStat("str", 1250);
    $npc->ModifyNPCStat("sta", 1250);
    $npc->ModifyNPCStat("agi", 1250);
    $npc->ModifyNPCStat("dex", 1250);
    $npc->ModifyNPCStat("wis", 1250);
    $npc->ModifyNPCStat("int", 1250);
    $npc->ModifyNPCStat("cha", 1100);

    # === Resists ===
    $npc->ModifyNPCStat("mr", 400);
    $npc->ModifyNPCStat("fr", 400);
    $npc->ModifyNPCStat("cr", 400);
    $npc->ModifyNPCStat("pr", 900);
    $npc->ModifyNPCStat("dr", 900);
    $npc->ModifyNPCStat("corruption_resist", 500);
    $npc->ModifyNPCStat("physical_resist", 1100);

    # === Traits & Abilities ===
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^12,1^13,1^14,1^15,1^17,1^21,1");

    # === Visual: Tint & Buff ===
    $npc->SetNPCTintIndex(30);
    $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

    # === Name Tag / Title ===
    my $base_name = $npc->GetCleanName();
    my $title_tag = "the Reflected";
    my $new_name  = ($base_name =~ /\bReflected\b/i) ? $base_name : "$base_name $title_tag";
    $npc->TempName($new_name);
    $npc->ModifyNPCStat("lastname", "Reflected");

    # === Raid Scaling (last) ===
    plugin::RaidScaling($entity_list, $npc);

    # === Full heal ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Shout and Disc Init ===
    $npc->Shout("What imbecile dares challenge a Celestial Fist?! Do you even know who you are challenging? HA! You are nothing but an insect! I will enjoy crushing you, I have not charred the flesh of an idiot in decades! If you truly wish to fight me, the battle shall be held in my own element. Come, challenger, come down to the pits of flowing fire.");

    quest::setnexthpevent(90); # Start disc rotation
    quest::settimer("leopard_claw", 30); # DD spam every 30s
}

sub EVENT_HP {
    if ($hpevent == 90) {
        $npc->CastSpell(4510, $npc->GetID()); # Stonestance — opener tank disc
        quest::setnexthpevent(70);
    }
    elsif ($hpevent == 70) {
        $npc->CastSpell(4691, $npc->GetID()); # Speedfocus — attack speed spike
        quest::setnexthpevent(50);
    }
    elsif ($hpevent == 50) {
        $npc->CastSpell(4512, $npc->GetID()); # Innerflame — high DPS mode
        quest::setnexthpevent(30);
    }
    elsif ($hpevent == 30) {
        $npc->CastSpell(4509, $npc->GetID()); # Whirlwind — riposte/final stand
    }
}

sub EVENT_TIMER {
    if ($timer eq "leopard_claw") {
        my $target = $npc->GetHateTop();
        if ($target && $target->IsClient()) {
            $npc->CastSpell(6752, $target->GetID()); # Leopard Claw
        }
    }
}