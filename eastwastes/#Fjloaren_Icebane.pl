sub EVENT_SPAWN {
    # === Boss Stat Application ===
    $npc->ModifyNPCStat("level", 60);
    $npc->ModifyNPCStat("ac", 18000);
    $npc->ModifyNPCStat("max_hp", 2000000);
    $npc->ModifyNPCStat("hp_regen", 2000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 4000);
    $npc->ModifyNPCStat("max_hit", 5500);
    $npc->ModifyNPCStat("atk", 1000);
    $npc->ModifyNPCStat("accuracy", 1000);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 7);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 70);
    $npc->ModifyNPCStat("aggro", 50);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 900);
    $npc->ModifyNPCStat("sta", 900);
    $npc->ModifyNPCStat("agi", 900);
    $npc->ModifyNPCStat("dex", 900);
    $npc->ModifyNPCStat("wis", 900);
    $npc->ModifyNPCStat("int", 900);
    $npc->ModifyNPCStat("cha", 700);

    $npc->ModifyNPCStat("mr", 200);
    $npc->ModifyNPCStat("fr", 200);
    $npc->ModifyNPCStat("cr", 200);
    $npc->ModifyNPCStat("pr", 200);
    $npc->ModifyNPCStat("dr", 200);
    $npc->ModifyNPCStat("corruption_resist", 200);
    $npc->ModifyNPCStat("physical_resist", 500);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_DEATH_COMPLETE {
    # Send SIGNAL 1 to the zone controller with NPC ID 724075
    quest::signalwith(10, 1, 0); # Signal 1, no delay
}