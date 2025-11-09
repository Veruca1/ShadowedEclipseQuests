# ===========================================================
# 1832.pl — a_tunarian_bramble (Plane of Growth)
# Shadowed Eclipse Scaling System
# - Applies tuned trash baseline stats
# - Uses RaidScaling for adaptive power scaling
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Trash Baseline Stats (from growthplane default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 58);
    $npc->ModifyNPCStat("ac", 11500);
    $npc->ModifyNPCStat("max_hp", 150000);
    $npc->ModifyNPCStat("hp_regen", 800);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 5500);
    $npc->ModifyNPCStat("max_hit", 6500);
    $npc->ModifyNPCStat("atk", 950);
    $npc->ModifyNPCStat("accuracy", 900);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 7);
    $npc->ModifyNPCStat("heroic_strikethrough", 5);
    $npc->ModifyNPCStat("slow_mitigation", 65);
    $npc->ModifyNPCStat("aggro", 50);
    $npc->ModifyNPCStat("assist", 1);

    # === Attribute and Resist Setup ===
    $npc->ModifyNPCStat("str", 800);
    $npc->ModifyNPCStat("sta", 800);
    $npc->ModifyNPCStat("agi", 800);
    $npc->ModifyNPCStat("dex", 800);
    $npc->ModifyNPCStat("wis", 800);
    $npc->ModifyNPCStat("int", 800);
    $npc->ModifyNPCStat("cha", 600);

    $npc->ModifyNPCStat("mr", 180);
    $npc->ModifyNPCStat("fr", 180);
    $npc->ModifyNPCStat("cr", 180);
    $npc->ModifyNPCStat("pr", 180);
    $npc->ModifyNPCStat("dr", 180);
    $npc->ModifyNPCStat("corruption_resist", 150);
    $npc->ModifyNPCStat("physical_resist", 350);

    # === Vision & Behavior ===
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1");

    # === Apply RaidScaling for adaptive tuning ===
    plugin::RaidScaling($entity_list, $npc);

    # Ensure HP is full after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    # Signal NPC ID 127098 with signal 1337 when this NPC dies
    quest::signalwith(1873, 1337);
}