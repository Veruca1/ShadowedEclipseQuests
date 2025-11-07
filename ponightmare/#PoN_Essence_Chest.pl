# ===========================================================
# PoN Essence Chest
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    $npc->SetNPCFactionID(623);

    # === Core Stats ===
    $npc->ModifyNPCStat("level", "65");
    $npc->ModifyNPCStat("ac", "30000");
    $npc->ModifyNPCStat("max_hp", "200000000");
    $npc->ModifyNPCStat("hp_regen", "3000");
    $npc->ModifyNPCStat("min_hit", "60000");
    $npc->ModifyNPCStat("max_hit", "110000");
    $npc->ModifyNPCStat("attack_speed", "38");
    $npc->ModifyNPCStat("atk", "2500");
    $npc->ModifyNPCStat("accuracy", "2000");
    $npc->ModifyNPCStat("slow_mitigation", "90");

    # === Attributes ===
    $npc->ModifyNPCStat("str", "1200");
    $npc->ModifyNPCStat("sta", "1200");
    $npc->ModifyNPCStat("agi", "1200");
    $npc->ModifyNPCStat("dex", "1200");
    $npc->ModifyNPCStat("wis", "1200");
    $npc->ModifyNPCStat("int", "1200");
    $npc->ModifyNPCStat("cha", "1000");

    # === Resists ===
    $npc->ModifyNPCStat("mr", "400");
    $npc->ModifyNPCStat("fr", "400");
    $npc->ModifyNPCStat("cr", "400");
    $npc->ModifyNPCStat("pr", "400");
    $npc->ModifyNPCStat("dr", "400");
    $npc->ModifyNPCStat("corruption", "500");
    $npc->ModifyNPCStat("physical_resist", "1000");

    # === Special Abilities ===
    $npc->SetSpecialAbility(2, 1);
    $npc->SetSpecialAbility(3, 1);
    $npc->SetSpecialAbility(5, 1);
    $npc->SetSpecialAbility(7, 1);
    $npc->SetSpecialAbility(8, 1);
    $npc->SetSpecialAbility(13, 1);
    $npc->SetSpecialAbility(14, 1);
    $npc->SetSpecialAbility(15, 1);
    $npc->SetSpecialAbility(17, 1);
    $npc->SetSpecialAbility(21, 1);

    $npc->SetHP($npc->GetMaxHP());

    quest::ze(15, "A large chest appears and attacks!");
}