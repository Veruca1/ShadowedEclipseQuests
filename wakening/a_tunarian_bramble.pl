# ===========================================================
# a_tunarian_bramble.pl — Wakening Lands
# Trash mob baseline + RaidScaling + timed depop
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Trash Baseline (from wakening default.pl) ===
    $npc->SetNPCFactionID(623);

    $npc->ModifyNPCStat("level", 55);
    $npc->ModifyNPCStat("ac", 9500);
    $npc->ModifyNPCStat("max_hp", 275000);
    $npc->ModifyNPCStat("hp_regen", 700);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 4700);
    $npc->ModifyNPCStat("max_hit", 5700);
    $npc->ModifyNPCStat("atk", 850);
    $npc->ModifyNPCStat("accuracy", 850);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 7);
    $npc->ModifyNPCStat("heroic_strikethrough", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 60);
    $npc->ModifyNPCStat("aggro", 45);
    $npc->ModifyNPCStat("assist", 1);

    # Attributes / Resists (trash baseline)
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

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # Ensure full HP after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Start depop timer if idle ===
    quest::settimer("depop_timer", 120); # 2 minutes
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        quest::settimer("depop_timer", 120); # restart countdown when idle
    } elsif ($combat_state == 1) {
        quest::stoptimer("depop_timer"); # stop timer if engaged
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_timer") {
        quest::stoptimer("depop_timer");
        quest::depop();
        quest::signalwith(10, 2);  # Send signal to controller
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(10, 2);  # Notify controller on death
}