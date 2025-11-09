# ===========================================================
# 1774.pl — a_Kromrif_contractor (Kael Drakkel)
# Shadowed Eclipse: Velious Tier Trash Scaling
# - Applies Kael trash baseline stats
# - Integrates adaptive RaidScaling system
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Baseline Trash Stats (Kael Default) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 58);
    $npc->ModifyNPCStat("ac", 12500);
    $npc->ModifyNPCStat("max_hp", 120000);
    $npc->ModifyNPCStat("hp_regen", 800);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 6200);
    $npc->ModifyNPCStat("max_hit", 7400);
    $npc->ModifyNPCStat("atk", 950);
    $npc->ModifyNPCStat("accuracy", 900);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 5);
    $npc->ModifyNPCStat("attack_delay", 7);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 65);
    $npc->ModifyNPCStat("aggro", 50);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 850);
    $npc->ModifyNPCStat("sta", 850);
    $npc->ModifyNPCStat("agi", 850);
    $npc->ModifyNPCStat("dex", 850);
    $npc->ModifyNPCStat("wis", 800);
    $npc->ModifyNPCStat("int", 800);
    $npc->ModifyNPCStat("cha", 600);

    $npc->ModifyNPCStat("mr", 180);
    $npc->ModifyNPCStat("fr", 180);
    $npc->ModifyNPCStat("cr", 180);
    $npc->ModifyNPCStat("pr", 180);
    $npc->ModifyNPCStat("dr", 180);
    $npc->ModifyNPCStat("corruption_resist", 140);
    $npc->ModifyNPCStat("physical_resist", 360);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1");

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === Set HP to Max after Scaling ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1764, 3);
}