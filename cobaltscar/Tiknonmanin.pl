# ===========================================================
#  Tiknonmanin — Cobalt Scar Boss Encounter
#  Shadowed Eclipse Raid-Scaled Boss Script
#  - Applies tuned baseline stats
#  - Integrates RaidScaling for adaptive difficulty
#  - Periodically casts frost aura buff
#  - Spawns adds in waves
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Baseline Boss Stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 10000000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 8500);
    $npc->ModifyNPCStat("max_hit", 11500);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # === Core Attributes ===
    $npc->ModifyNPCStat("str", 950);
    $npc->ModifyNPCStat("sta", 950);
    $npc->ModifyNPCStat("agi", 950);
    $npc->ModifyNPCStat("dex", 950);
    $npc->ModifyNPCStat("wis", 950);
    $npc->ModifyNPCStat("int", 950);
    $npc->ModifyNPCStat("cha", 750);

    # === Resistances ===
    $npc->ModifyNPCStat("mr", 220);
    $npc->ModifyNPCStat("fr", 220);
    $npc->ModifyNPCStat("cr", 220);
    $npc->ModifyNPCStat("pr", 220);
    $npc->ModifyNPCStat("dr", 220);
    $npc->ModifyNPCStat("corruption_resist", 220);
    $npc->ModifyNPCStat("physical_resist", 550);

    # === Abilities / Vision / Behavior ===
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("runspeed", 2);

    # === Reset HP ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === Timers ===
    quest::settimer("check_buffs", 10);
    quest::settimer("depop_check", 1800);

    # === Optional Flavor Text ===
    quest::we(14, "From the icy mists of Cobalt Scar, Tiknonmanin emerges with a roar that shakes the coast!");
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        # Keep Frost Aura up out of combat
        if (!$npc->FindBuff(27376) && !$npc->IsEngaged()) {
            $npc->CastSpell(27376, $npc->GetID()); # Self frost buff
        }
    }
    elsif ($timer eq "spawn_adds") {
        # === Spawn Add Wave ===
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        for my $i (0..7) {
            my $angle = $i * (2 * 3.14159 / 8);
            my $add_x = $x + 12 * cos($angle);
            my $add_y = $y + 12 * sin($angle);
            quest::spawn2(1647, 0, 0, $add_x, $add_y, $z, $h); # Example add ID
        }
    }
    elsif ($timer eq "depop_check") {
        if (!$npc->IsEngaged()) {
            quest::signalwith(1407, 1); # optional controller
            quest::depop();
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # === Entered Combat ===
        quest::stoptimer("check_buffs");
        quest::settimer("spawn_adds", 30);   # Spawn adds every 30s
        quest::stoptimer("depop_check");     # Stop depop timer
    } elsif ($combat_state == 0) {
        # === Left Combat ===
        quest::stoptimer("spawn_adds");
        quest::settimer("check_buffs", 10);  # Resume buff upkeep
        quest::settimer("depop_check", 1800);
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1407, 1);
    quest::we(14, "Tiknonmanin’s bellow echoes through Cobalt Scar as the icy storm begins to calm...");
}