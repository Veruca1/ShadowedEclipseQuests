# ===========================================================
# 1873.pl — Tunare (Plane of Growth)
# Shadowed Eclipse Boss Logic
# - Applies tuned boss baseline stats
# - Uses RaidScaling for adaptive group power adjustment
# - Spawns minions and reacts to healing signals
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Boss Baseline Stats (from growthplane default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 63);
    $npc->ModifyNPCStat("ac", 24000);
    $npc->ModifyNPCStat("max_hp", 10000000);
    $npc->ModifyNPCStat("hp_regen", 3000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 9500);
    $npc->ModifyNPCStat("max_hit", 11000);
    $npc->ModifyNPCStat("atk", 1350);
    $npc->ModifyNPCStat("accuracy", 1250);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 9);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);

    # === Attributes and Resistances ===
    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 250);
    $npc->ModifyNPCStat("fr", 250);
    $npc->ModifyNPCStat("cr", 250);
    $npc->ModifyNPCStat("pr", 250);
    $npc->ModifyNPCStat("dr", 250);
    $npc->ModifyNPCStat("corruption_resist", 250);
    $npc->ModifyNPCStat("physical_resist", 600);

    # === Vision & Abilities ===
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # Ensure full HP after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Engaged in combat
        quest::settimer("spawn_minions", 30);  # Spawn minions every 30 seconds
    }
    elsif ($combat_state == 0) {  # Out of combat
        quest::stoptimer("spawn_minions");
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_minions") {
        # Spawn 2 Tunarian Brambles (1832) near Tunare’s position
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        quest::spawn2(1832, 0, 0, $x + 5, $y + 5, $z, $h);
        quest::spawn2(1832, 0, 0, $x - 5, $y - 5, $z, $h);
    }
}

sub EVENT_SIGNAL {
    if ($signal == 1337) {
        plugin::MobHealPercentage(15);
        quest::shout("The vines pulse with energy, giving their life to heal Tunare!");
    }
}