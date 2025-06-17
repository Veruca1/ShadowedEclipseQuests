sub EVENT_SPAWN {
    #quest::shout("The secrets of Akheva grow restless once more.");

    if (defined $npc) {
        $npc->ModifyNPCStat("level", 65);
        $npc->ModifyNPCStat("ac", 40000);
        $npc->ModifyNPCStat("max_hp", 22000000);
        $npc->SetHP($npc->GetMaxHP());
        $npc->ModifyNPCStat("hp_regen", 1000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 15000);
        $npc->ModifyNPCStat("max_hit", 18000);
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

        my @buffs = (
        5278,   # Hand of Conviction
        5297,   # Brell's Brawny Bulwark
        5488,   # Circle of Fireskin
        10028,  # Talisman of Persistence
        10031,  # Talisman of the Stoic One
        10013,  # Talisman of Foresight
        10664,  # Voice of Intuition
        9414,   # Holy Battle Hymn V
        300,    # Boon of the Avenging Angel IV
        15031,  # Strength of Gladwalker
        2530,   # Khura's Focusing
        20147   # Nimbus of Discordant Spines
    );

    foreach my $spell_id (@buffs) {
        $npc->ApplySpellBuff($spell_id);
    }
        
    }
}