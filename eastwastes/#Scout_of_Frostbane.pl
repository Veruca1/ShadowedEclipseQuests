# ===========================================================
# 116XXX.pl — Eastern Wastes Boss
# Shadowed Eclipse Standard Boss Logic
# - Uses default.pl boss stat baseline for consistency
# - Maintains self-buff and timed add spawns
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Boss Baseline Stats (from default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 60);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 2000000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 4500);
    $npc->ModifyNPCStat("max_hit", 6500);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 950);
    $npc->ModifyNPCStat("sta", 950);
    $npc->ModifyNPCStat("agi", 950);
    $npc->ModifyNPCStat("dex", 950);
    $npc->ModifyNPCStat("wis", 950);
    $npc->ModifyNPCStat("int", 950);
    $npc->ModifyNPCStat("cha", 750);

    $npc->ModifyNPCStat("mr", 220);
    $npc->ModifyNPCStat("fr", 220);
    $npc->ModifyNPCStat("cr", 220);
    $npc->ModifyNPCStat("pr", 220);
    $npc->ModifyNPCStat("dr", 220);
    $npc->ModifyNPCStat("corruption_resist", 220);
    $npc->ModifyNPCStat("physical_resist", 550);

    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("runspeed", 2);

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Timers ===
    quest::settimer("check_buffs", 1);  # Maintain self-buff
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");

        # Apply persistent self-buff (spell 27376)
        $npc->CastSpell(27376, $npc->GetID()) if !$npc->FindBuff(27376);

        quest::settimer("check_buffs", 1);
    }

    elsif ($timer eq "spawn_adds") {
        # Spawn 3 adds (NPC ID 1647) near the boss
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        quest::spawn2(1647, 0, 0, $x + 8, $y + 8, $z, $h);
        quest::spawn2(1647, 0, 0, $x - 8, $y - 8, $z, $h);
        quest::spawn2(1647, 0, 0, $x, $y, $z + 6, $h);
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Start add spawn loop when combat begins
        quest::settimer("spawn_adds", 25);
    }
    elsif ($combat_state == 0) {
        # Stop spawning adds when combat ends
        quest::stoptimer("spawn_adds");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Notify zone controller or global handler
    quest::signalwith(10, 1, 0);
}