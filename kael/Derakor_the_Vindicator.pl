# ===========================================================
# 1756.pl — Derakor_the_Vindicator (Kael Drakkel)
# Shadowed Eclipse: Velious Tier Boss Scaling
# - Applies Kael baseline boss stats
# - Integrates adaptive RaidScaling system
# - Signals announcer (1764) on death
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Baseline Boss Stats (Kael Default) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 25000);
    $npc->ModifyNPCStat("max_hp", 2000000);
    $npc->ModifyNPCStat("hp_regen", 3000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 9500);
    $npc->ModifyNPCStat("max_hit", 12500);
    $npc->ModifyNPCStat("atk", 1400);
    $npc->ModifyNPCStat("accuracy", 1200);
    $npc->ModifyNPCStat("avoidance", 55);
    $npc->ModifyNPCStat("heroic_strikethrough", 10);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 85);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    # === Core Attributes ===
    $npc->ModifyNPCStat("str", 1100);
    $npc->ModifyNPCStat("sta", 1100);
    $npc->ModifyNPCStat("agi", 1100);
    $npc->ModifyNPCStat("dex", 1100);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 850);

    # === Resist Profiles ===
    $npc->ModifyNPCStat("mr", 260);
    $npc->ModifyNPCStat("fr", 260);
    $npc->ModifyNPCStat("cr", 260);
    $npc->ModifyNPCStat("pr", 260);
    $npc->ModifyNPCStat("dr", 260);
    $npc->ModifyNPCStat("corruption_resist", 260);
    $npc->ModifyNPCStat("physical_resist", 650);

    # === Visibility and Behavior ===
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # === Special Abilities ===
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^12,1");

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === Set HP to Max after Scaling ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    # Signal announcer (1764) when slain
    quest::signalwith(1764, 4);
}