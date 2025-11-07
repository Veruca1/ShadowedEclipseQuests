# ===========================================================
# Custom NPC — Great Divide Trash Template
# Applies Great Divide trash stats and RaidScaling
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Apply Great Divide Trash Stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 55);
    $npc->ModifyNPCStat("ac", 9500);
    $npc->ModifyNPCStat("max_hp", 220000);
    $npc->ModifyNPCStat("hp_regen", 700);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 4000);
    $npc->ModifyNPCStat("max_hit", 5000);
    $npc->ModifyNPCStat("atk", 850);
    $npc->ModifyNPCStat("accuracy", 850);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 4);
    $npc->ModifyNPCStat("attack_delay", 7);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 60);
    $npc->ModifyNPCStat("aggro", 45);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 750);
    $npc->ModifyNPCStat("sta", 750);
    $npc->ModifyNPCStat("agi", 750);
    $npc->ModifyNPCStat("dex", 750);
    $npc->ModifyNPCStat("wis", 750);
    $npc->ModifyNPCStat("int", 750);
    $npc->ModifyNPCStat("cha", 550);

    $npc->ModifyNPCStat("mr", 160);
    $npc->ModifyNPCStat("fr", 160);
    $npc->ModifyNPCStat("cr", 160);
    $npc->ModifyNPCStat("pr", 160);
    $npc->ModifyNPCStat("dr", 160);
    $npc->ModifyNPCStat("corruption_resist", 130);
    $npc->ModifyNPCStat("physical_resist", 320);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1");

    # Apply RaidScaling (adaptive difficulty)
    plugin::RaidScaling($entity_list, $npc);

    # === Buff logic ===
    my @buffs = (12934, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());
    }

    quest::settimer("recast_buffs", 90); # refresh buffs every 90 seconds
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # In combat
        if ($npc->GetHateTop()) {
            quest::castspell(40598, $npc->GetHateTop()->GetID()); # Tempestas Fulgoris!
        }
        quest::settimer("stun", 20);
    }
    else {  # Out of combat
        quest::stoptimer("stun");
    }
}

sub EVENT_TIMER {
    if ($timer eq "stun") {
        if ($npc->GetHateTop()) {
            quest::castspell(40598, $npc->GetHateTop()->GetID());
        }
    }

    if ($timer eq "recast_buffs") {
        my @buffs = (12934, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("stun");
    quest::stoptimer("recast_buffs");

    # Optional spawns
    quest::spawn2(1636, 0, 0, 51.38, 259.54, -2.38, 133.25);
    quest::spawn2(1637, 0, 0, 79.50, 289.00, -2.38, 320.25);
}