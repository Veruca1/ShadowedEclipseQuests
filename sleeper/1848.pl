# ===========================================================
# Frostbane`s_Right_Hand (NPC ID 1848)
# HP-driven switching logic integrated with zone controller
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Baseline stats (same as before) ===
    $npc->SetNPCFactionID(623);   # Active faction on spawn
    $npc->ModifyNPCStat("level", 61);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 10050000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 8000);
    $npc->ModifyNPCStat("max_hit", 9700);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # === Attributes & Resists ===
    for my $stat (qw(str sta agi dex wis int)) { $npc->ModifyNPCStat($stat, 950); }
    $npc->ModifyNPCStat("cha", 750);
    for my $res (qw(mr fr cr pr dr corruption_resist)) { $npc->ModifyNPCStat($res, 220); }
    $npc->ModifyNPCStat("physical_resist", 550);

    # === Special Abilities ===
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === HP Triggers for rotation ===
    quest::setnexthpevent(80);

    # === START ACTIVE ===
    $npc->SetInvul(0);
    $npc->SetSpecialAbility(24, 0);
    $npc->SetSpecialAbility(25, 0);
    $npc->SetSpecialAbility(35, 0);

     my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    quest::emote("cracks apart, the Right Hand of Frostbane awakens!");
}

sub EVENT_HP {
    if ($hpevent == 80) {
        quest::signalwith(10, 100);  # signal controller HP event
        quest::setnexthpevent(40);
    } elsif ($hpevent == 40) {
        quest::signalwith(10, 101);
        quest::setnexthpevent(10);
    } elsif ($hpevent == 10) {
        quest::signalwith(10, 102);
    }
}

sub EVENT_SIGNAL {
    if ($signal == 1) { # Activate
        $npc->WipeHateList();
        $npc->SetNPCFactionID(623);
        $npc->SetInvul(0);
        $npc->SetSpecialAbility(24, 0);
        $npc->SetSpecialAbility(25, 0);
        $npc->SetSpecialAbility(35, 0);
        quest::emote("stirs and lashes out in fury!");
    }
    elsif ($signal == 2) { # Freeze
        $npc->WipeHateList();
        $npc->SetNPCFactionID(0);
        $npc->SetInvul(1);
        $npc->SetSpecialAbility(24, 1);
        $npc->SetSpecialAbility(25, 1);
        $npc->SetSpecialAbility(35, 1);
        quest::emote("freezes solid, its energy dimming...");
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 11);
}