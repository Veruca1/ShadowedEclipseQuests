# ===========================================================
# Gorathrix,_the_Infernal
# Shadowed Eclipse — Necropolis Boss Scaling
# - Applies boss baseline stats
# - Uses RaidScaling for adaptive group power adjustment
# - No optional mechanics
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Intro Marquee ===
    $npc->CameraEffect(1000, 3);

    my @clients = $entity_list->GetClientList();
    my $text = "You feel a disturbance and an immense heat from the north.";

    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
    }

    # === Boss Baseline Stats (from Necropolis default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 25000);
    $npc->ModifyNPCStat("max_hp", 1750000);
    $npc->ModifyNPCStat("hp_regen", 3200);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 9800);
    $npc->ModifyNPCStat("max_hit", 13000);
    $npc->ModifyNPCStat("atk", 1450);
    $npc->ModifyNPCStat("accuracy", 1220);
    $npc->ModifyNPCStat("avoidance", 55);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 10);
    $npc->ModifyNPCStat("slow_mitigation", 85);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # === Core Attributes ===
    $npc->ModifyNPCStat("str", 1150);
    $npc->ModifyNPCStat("sta", 1150);
    $npc->ModifyNPCStat("agi", 1150);
    $npc->ModifyNPCStat("dex", 1150);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 850);

    # === Resistances ===
    $npc->ModifyNPCStat("mr", 280);
    $npc->ModifyNPCStat("fr", 280);
    $npc->ModifyNPCStat("cr", 280);
    $npc->ModifyNPCStat("pr", 280);
    $npc->ModifyNPCStat("dr", 280);
    $npc->ModifyNPCStat("corruption_resist", 260);
    $npc->ModifyNPCStat("physical_resist", 675);

    # === Special Abilities ===
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^12,1");

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === Reset HP to Full ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}