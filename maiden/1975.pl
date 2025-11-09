sub EVENT_SPAWN {
    #quest::shout("The secrets of Akheva grow restless once more.");

    if (defined $npc) {
        $npc->ModifyNPCStat("level", 63);
        $npc->ModifyNPCStat("ac", 40000);
        $npc->ModifyNPCStat("max_hp", 5000000);
        $npc->SetHP($npc->GetMaxHP());
        $npc->ModifyNPCStat("hp_regen", 1000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 8500);
        $npc->ModifyNPCStat("max_hit", 13000);
        $npc->ModifyNPCStat("atk", 1400);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 150);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 30);
        $npc->ModifyNPCStat("aggro", 60);
        $npc->ModifyNPCStat("assist", 1);

        $npc->ModifyNPCStat("str", 1200);
        $npc->ModifyNPCStat("sta", 1200);
        $npc->ModifyNPCStat("agi", 1200);
        $npc->ModifyNPCStat("dex", 1200);
        $npc->ModifyNPCStat("wis", 1200);
        $npc->ModifyNPCStat("int", 1200);
        $npc->ModifyNPCStat("cha", 1000);

        $npc->ModifyNPCStat("mr", 200);
        $npc->ModifyNPCStat("fr", 200);
        $npc->ModifyNPCStat("cr", 200);
        $npc->ModifyNPCStat("pr", 200);
        $npc->ModifyNPCStat("dr", 200);
        $npc->ModifyNPCStat("corruption_resist", 500);
        $npc->ModifyNPCStat("physical_resist", 1000);

        $npc->ModifyNPCStat("runspeed", 0);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5^7,1^8,1^13,1^14,1^17,1^21,1^31,1^33,1");
        
    }
}

sub EVENT_DEATH_COMPLETE {
    # Clean up
    quest::depopall(1974);
    quest::depopall(1973);
    quest::signalwith(1937, 1);  # Send signal 1 to NPC 1937
    if (int(rand(100)) < 20) {
        quest::spawn2(1976, 0, 0, $x, $y, $z, $h);
    }
}