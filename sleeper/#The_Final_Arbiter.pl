# ===========================================================
# #The_Final_Arbiter (NPC ID 1878)
# Sleeper's Tomb Boss — Shadowed Eclipse Scaling System
# - Applies tuned post-Velious boss stats on spawn
# - Integrates RaidScaling for adaptive raid tuning
# - Preserves add spawn HP-event logic and death spawns
# ===========================================================

my %spawned = ();  # Track spawned sentries

sub EVENT_SPAWN {
    return unless $npc;

    # === Sleeper's Tomb Boss Baseline Stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 61);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 1750000);
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

    # === Finalize HP ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Original Spawn Logic (Preserved) ===
    quest::setnexthpevent(80);
}

sub EVENT_HP {
    my %hp_to_next = (
        80 => 60,
        60 => 40,
        40 => 15,
        15 => 1,
    );

    if ($npc->IsEngaged()) {  # Ensure the boss is in combat
        if ($hpevent == 80 && !$spawned{80}) {
            SpawnAdds();
            $spawned{80} = 1;
        }
        elsif ($hpevent == 60 && !$spawned{60}) {
            SpawnAdds();
            $spawned{60} = 1;
        }
        elsif ($hpevent == 40 && !$spawned{40}) {
            SpawnAdds();
            $spawned{40} = 1;
        }
        elsif ($hpevent == 15 && !$spawned{15}) {
            SpawnAdds();
            $spawned{15} = 1;
        }

        quest::setnexthpevent($hp_to_next{$hpevent}) if exists $hp_to_next{$hpevent};
    }
}

sub SpawnAdds {
    quest::spawn2(128063, 0, 0, $x, $y, $z, $h);
}

sub EVENT_DEATH_COMPLETE {
    # === Original Death Logic (Preserved) ===
    quest::spawn2(128041, 0, 0, -1073.49, -1961.97, -988.87, 383.50);
    quest::spawn2(128042, 0, 0, -1905.96, -1968.76, -991.27, 257.00);
    quest::spawn2(128043, 0, 0, -1896.34, -2799.74, -991.63, 129.75);
    quest::spawn2(128044, 0, 0, -1070.40, -2767.78, -992.50, 7.00);
}