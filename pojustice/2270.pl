# ===============================================================
# Tribunal Guardian (2266–2271) — Activation Logic + Trash Stats
# ===============================================================
# - Starts inert: invulnerable, immune to all damage/aggro
# - On signal 1: becomes vulnerable, enables aggro, normal stats
# ===============================================================

sub EVENT_SPAWN {
    return unless $npc;
    return if $npc->IsPet();

    # Inert Setup
    $npc->SetNPCFactionID(0);     # Neutral faction
    $npc->SetInvul(1);            # Undamageable

    # Trash Stats (until activated)
    $npc->ModifyNPCStat("level", 63);
    $npc->ModifyNPCStat("ac",        22000);
    $npc->ModifyNPCStat("max_hp",    20000000);
    $npc->ModifyNPCStat("hp_regen",  1000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit",   45000);
    $npc->ModifyNPCStat("max_hit",   58000);
    $npc->ModifyNPCStat("atk",       2400);
    $npc->ModifyNPCStat("accuracy",  1900);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 30);
    $npc->ModifyNPCStat("attack_delay", 7);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("aggro", 100);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1050);
    $npc->ModifyNPCStat("sta", 1050);
    $npc->ModifyNPCStat("agi", 1050);
    $npc->ModifyNPCStat("dex", 1050);
    $npc->ModifyNPCStat("wis", 1050);
    $npc->ModifyNPCStat("int", 1050);
    $npc->ModifyNPCStat("cha", 850);

    $npc->ModifyNPCStat("mr", 320);
    $npc->ModifyNPCStat("fr", 320);
    $npc->ModifyNPCStat("cr", 320);
    $npc->ModifyNPCStat("pr", 320);
    $npc->ModifyNPCStat("dr", 320);

    $npc->ModifyNPCStat("corruption_resist", 350);
    $npc->ModifyNPCStat("physical_resist",   850);

    # Unified Special Abilities (All inert protections included)
    $npc->ModifyNPCStat("special_abilities",
        "3,1^5,1^7,1^8,1^9,1^10,1^14,1" .    # Base NPC protections
        "^19,1^20,1^22,1^23,1^24,1^25,1^26,1^28,1^35,1^39,1^46,1"  # Inert/immune state
    );

    # Set HP to full after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # Optional raid scaling
    plugin::RaidScaling($entity_list, $npc);
}

sub EVENT_SIGNAL {
    if ($signal == 1) {
        $npc->SetInvul(0);
        $npc->SetNPCFactionID(623);     # Set proper faction when activating

        # Disable all previously enabled special abilities
        $npc->SetSpecialAbility(19,0);  # Immune to Melee
        $npc->SetSpecialAbility(20,0);  # Immune to Magic
        $npc->SetSpecialAbility(22,0);  # Immune to non-Bane Melee
        $npc->SetSpecialAbility(23,0);  # Immune to non-Magical Melee
        $npc->SetSpecialAbility(24,0);  # Will not Aggro
        $npc->SetSpecialAbility(25,0);  # Immune to Aggro
        $npc->SetSpecialAbility(26,0);  # Resist Ranged Spells
        $npc->SetSpecialAbility(28,0);  # Immune to Taunt
        $npc->SetSpecialAbility(35,0);  # Rooted
        $npc->SetSpecialAbility(39,0);  # Disable Melee
        $npc->SetSpecialAbility(46,0);  # Immune to Ranged Attacks

        quest::emote("judges your presence and prepares for battle!");
    }
}