# ===========================================================
# a_phase_spider (1791)
# Shadowed Eclipse — Necropolis Trash Scaling
# - Applies trash baseline stats
# - Uses RaidScaling for adaptive difficulty
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Trash Baseline Stats (from Necropolis default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 59);
    $npc->ModifyNPCStat("ac", 13000);
    $npc->ModifyNPCStat("max_hp", 150000);
    $npc->ModifyNPCStat("hp_regen", 850);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 6400);
    $npc->ModifyNPCStat("max_hit", 7800);
    $npc->ModifyNPCStat("atk", 975);
    $npc->ModifyNPCStat("accuracy", 920);
    $npc->ModifyNPCStat("avoidance", 55);
    $npc->ModifyNPCStat("attack_delay", 7);
    $npc->ModifyNPCStat("heroic_strikethrough", 5);
    $npc->ModifyNPCStat("slow_mitigation", 65);
    $npc->ModifyNPCStat("aggro", 50);
    $npc->ModifyNPCStat("assist", 1);
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # === Core Attributes ===
    $npc->ModifyNPCStat("str", 875);
    $npc->ModifyNPCStat("sta", 875);
    $npc->ModifyNPCStat("agi", 875);
    $npc->ModifyNPCStat("dex", 875);
    $npc->ModifyNPCStat("wis", 800);
    $npc->ModifyNPCStat("int", 800);
    $npc->ModifyNPCStat("cha", 600);

    # === Resistances ===
    $npc->ModifyNPCStat("mr", 190);
    $npc->ModifyNPCStat("fr", 190);
    $npc->ModifyNPCStat("cr", 190);
    $npc->ModifyNPCStat("pr", 190);
    $npc->ModifyNPCStat("dr", 190);
    $npc->ModifyNPCStat("corruption_resist", 150);
    $npc->ModifyNPCStat("physical_resist", 375);

    # === Special Abilities ===
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1");

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === Reset HP to Full ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    my $chance = int(rand(100)) + 1;
    if ($chance <= 30) {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();
        quest::spawn2(1792, 0, 0, $x, $y, $z, $h);
    }
}