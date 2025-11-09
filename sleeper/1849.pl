# ===========================================================
# Frostbane`s_Left_Hand (NPC ID 1849)
# Sleeper's Tomb Boss — Shadowed Eclipse Scaling System
# - Applies tuned post-Velious boss stats on spawn
# - Integrates RaidScaling for adaptive raid tuning
# - Swaps active/invulnerable state via HP-triggered signals
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Sleeper's Tomb Boss Baseline Stats ===
    $npc->SetNPCFactionID(0);
    $npc->ModifyNPCStat("level", 61);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 10500000);
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

    # === Attributes & Resistances ===
    for my $stat (qw(str sta agi dex wis int)) { $npc->ModifyNPCStat($stat, 950); }
    $npc->ModifyNPCStat("cha", 750);
    for my $res (qw(mr fr cr pr dr corruption_resist)) { $npc->ModifyNPCStat($res, 220); }
    $npc->ModifyNPCStat("physical_resist", 550);

    # === Vision & AI Traits ===
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);

    # === Special Abilities (Immunities) ===
    # 3: immune to fleeing | 5: immune to mez | 7: immune to charm
    # 8: immune to fear | 9: immune to root
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === HP Events for rotation triggers ===
    quest::setnexthpevent(80);

    # === Start Invulnerable ===
    $npc->SetInvul(1);
    $npc->SetSpecialAbility(24, 1);  # Immune to melee
    $npc->SetSpecialAbility(25, 1);  # Immune to spells
    $npc->SetSpecialAbility(35, 1);  # Immune to AE rampage
     my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

# ===========================================================
# HP-based rotation logic — notifies controller on thresholds
# ===========================================================
sub EVENT_HP {
    if ($hpevent == 80) {
        quest::signalwith(10, 200);  # Notify controller (Left triggered 80%)
        quest::setnexthpevent(40);
    }
    elsif ($hpevent == 40) {
        quest::signalwith(10, 201);  # Notify controller (Left triggered 40%)
        quest::setnexthpevent(10);
    }
    elsif ($hpevent == 10) {
        quest::signalwith(10, 202);  # Notify controller (Left triggered 10%)
    }
}

# ===========================================================
# Signal 1 = Activate (vulnerable)
# Signal 2 = Freeze (invulnerable)
# ===========================================================
sub EVENT_SIGNAL {
    if ($signal == 1) {  # Activate
        $npc->WipeHateList();
        $npc->SetNPCFactionID(623);
        $npc->SetInvul(0);
        $npc->SetSpecialAbility(24, 0);
        $npc->SetSpecialAbility(25, 0);
        $npc->SetSpecialAbility(35, 0);
        quest::emote("erupts with glacial fury!");
    }
    elsif ($signal == 2) {  # Freeze
        $npc->WipeHateList();
        $npc->SetNPCFactionID(0);
        $npc->SetInvul(1);
        $npc->SetSpecialAbility(24, 1);
        $npc->SetSpecialAbility(25, 1);
        $npc->SetSpecialAbility(35, 1);
        quest::emote("hardens into motionless ice...");
    }
}

# ===========================================================
# Death - Inform controller that this hand is defeated
# ===========================================================
sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 11);
}