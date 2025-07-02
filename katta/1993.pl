sub EVENT_SPAWN {
    return unless $npc;

    # BOSS STATS
    $npc->ModifyNPCStat("level", 63);
    $npc->ModifyNPCStat("ac", 50000);             # More AC for melee mitigation
    $npc->ModifyNPCStat("max_hp", 25000000);      # Big HP pool
    $npc->ModifyNPCStat("hp_regen", 200000);      # Strong regen
    $npc->ModifyNPCStat("mana_regen", 10000);

    $npc->ModifyNPCStat("min_hit", 9000);
    $npc->ModifyNPCStat("max_hit", 15000);
    $npc->ModifyNPCStat("atk", 1600);
    $npc->ModifyNPCStat("accuracy", 2000);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("slow_mitigation", 100);

    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 32);

    $npc->ModifyNPCStat("str", 1200);
    $npc->ModifyNPCStat("sta", 1200);
    $npc->ModifyNPCStat("agi", 1200);
    $npc->ModifyNPCStat("dex", 1200);
    $npc->ModifyNPCStat("wis", 1200);
    $npc->ModifyNPCStat("int", 1200);
    $npc->ModifyNPCStat("cha", 1000);

    $npc->ModifyNPCStat("mr", 170);
    $npc->ModifyNPCStat("fr", 170);
    $npc->ModifyNPCStat("cr", 170);
    $npc->ModifyNPCStat("pr", 170);
    $npc->ModifyNPCStat("dr", 170);
    $npc->ModifyNPCStat("corruption_resist", 500);
    $npc->ModifyNPCStat("physical_resist", 10000);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # ✅ CORRECT SPECIAL ABILITIES FOR YOUR SERVER
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^4,1^5,1^12,1^13,1^14,1^15,1^16,1^17,1^21,1^29,1");

    # Heal to full after stat change
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

# ✅ Halves spell damage only
sub EVENT_DAMAGE {
    my ($damage, $spell_id, $attacker) = @_;
    my $new_damage = int($damage * 0.5);
    return $new_damage;
}

sub EVENT_DEATH_COMPLETE {
    quest::spawn2(1994, 0, 0, $x, $y, $z, $h);
}