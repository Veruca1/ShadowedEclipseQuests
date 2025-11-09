#Vulak`Aerr - UD Version
# ===========================================================
# an_onyx_sky_drake (1901)
# Temple of Veeshan — Shadowed Eclipse Trash Mob
# - Applies custom ToV trash baseline stats
# - Integrates RaidScaling for adaptive group/raid scaling
# - Hunts random players periodically
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Baseline ToV Boss Stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 63);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 3500000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 9000);
    $npc->ModifyNPCStat("max_hit", 11000);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # === Attribute & Resist Setup ===
    $npc->ModifyNPCStat("str", 950);
    $npc->ModifyNPCStat("sta", 950);
    $npc->ModifyNPCStat("agi", 950);
    $npc->ModifyNPCStat("dex", 950);
    $npc->ModifyNPCStat("wis", 950);
    $npc->ModifyNPCStat("int", 950);
    $npc->ModifyNPCStat("cha", 750);

    $npc->ModifyNPCStat("mr", 220);
    $npc->ModifyNPCStat("fr", 220);
    $npc->ModifyNPCStat("cr", 220);
    $npc->ModifyNPCStat("pr", 220);
    $npc->ModifyNPCStat("dr", 220);
    $npc->ModifyNPCStat("corruption_resist", 220);
    $npc->ModifyNPCStat("physical_resist", 550);

    # === Immunities and Behavior ===
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # === Raid Scaling Integration ===
    plugin::RaidScaling($entity_list, $npc);

    # === Set HP to Max ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 50);

    if (!quest::isnpcspawned(2145)) {
        quest::spawn2(2145, 0, 0, -1376.79, 1801.93, 172.06, 126.75);
    }

    if (!quest::isnpcspawned(2163)) {
        quest::spawn2(2163, 0, 0, -1341.79, 1798.97, 167.63, 132.50);
    }
}