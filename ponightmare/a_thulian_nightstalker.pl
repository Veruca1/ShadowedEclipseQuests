#a_thulian_nightstalker

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # === Faction ===
    $npc->SetNPCFactionID(623);

    # === Stats ===
    $npc->ModifyNPCStat("level", 62);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 15000000);
    $npc->ModifyNPCStat("hp_regen", 800);
    $npc->ModifyNPCStat("min_hit", 44000);
    $npc->ModifyNPCStat("max_hit", 55000);
    $npc->ModifyNPCStat("attack_speed", 30);
    $npc->ModifyNPCStat("atk", 2500);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # === Attributes ===
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    # === Resists ===
    $npc->ModifyNPCStat("mr", 300);
    $npc->ModifyNPCStat("fr", 300);
    $npc->ModifyNPCStat("cr", 300);
    $npc->ModifyNPCStat("pr", 300);
    $npc->ModifyNPCStat("dr", 300);
    $npc->ModifyNPCStat("corruption", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    # === Special Abilities ===
    # 3 - immune to mez, 5 - immune to charm, 7 - immune to fear,
    # 8 - immune to stun, 9 - immune to snare, 10 - immune to root, 14 - uncharmable
    $npc->SetSpecialAbility(3, 1);
    $npc->SetSpecialAbility(5, 1);
    $npc->SetSpecialAbility(7, 1);
    $npc->SetSpecialAbility(8, 1);
    $npc->SetSpecialAbility(9, 1);
    $npc->SetSpecialAbility(10, 1);
    $npc->SetSpecialAbility(14, 1);

    # === Ensure full HP ===
    $npc->SetHP($npc->GetMaxHP());
}

sub EVENT_DEATH_COMPLETE

   {
   quest::signalwith(204016,6,0); # NPC: Thelin_Poxbourne
   } 