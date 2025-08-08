sub EVENT_SPAWN {
    return unless $npc;
    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    # Exclusion list check
    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Spawn intro message (Black Mirror / Eclipse theme)
    quest::shout("I see you... from the other side of the mirror.");

    # Apply base stats
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac", 29000);
    $npc->ModifyNPCStat("max_hp", 250000000);
    $npc->ModifyNPCStat("hp_regen", 1700);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 40000);
    $npc->ModifyNPCStat("max_hit", 90000);
    $npc->ModifyNPCStat("atk", 1800);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 5);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 21);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    # Heal to full HP
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # Buffs & Nimbus timers
    quest::settimer("init_effects", 1);        # Buffs after 1 second
    quest::settimer("lunar_nimbus_buff", 8);   # Nimbus after 8 seconds
}

sub EVENT_TIMER {
    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");

        # Self-buffs
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
            2530    # Khura's Focusing
        );

        foreach my $spell_id (@buffs) {
            $npc->SpellFinished($spell_id, $npc);
        }
    }
    elsif ($timer eq "lunar_nimbus_buff") {
        quest::stoptimer("lunar_nimbus_buff");
        $npc->CastSpell(20146, $npc->GetID()) if !$npc->FindBuff(20146); # Lunar Nimbus
    }
}