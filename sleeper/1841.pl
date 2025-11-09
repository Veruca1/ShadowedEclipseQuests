# ===========================================================
# Welcome_Wagon — Sleeper's Tomb Boss
# Shadowed Eclipse Scaling System
# - Applies tuned post-Velious boss stats on spawn
# - Integrates RaidScaling for adaptive raid tuning
# - Includes cinematic intro, spell attacks, and minion phases
# ===========================================================

my $spell_casted     = 0;  # Track if the spell has been cast
my $damage_applied   = 0;  # Track if the 75% max HP damage has been applied
my $minions_spawned  = 0;  # Track phase spawns

sub EVENT_SPAWN {
    return unless $npc;

    # === Sleeper's Tomb Boss Baseline Stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 61);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 2200000);
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

    # === Intro Cinematic ===
    $npc->CameraEffect(1000, 3);

    my @clients = $entity_list->GetClientList();
    my $text = "You hear maniacal laughter echo throughout the tomb.";
    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
    }

    quest::shout("We meet again my old friend! Hahahaha!");

    # Start a timer to shout and cast the spell after 20 seconds
    quest::settimer("shout_spell", 20);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat started
        quest::settimer("spell_cast", 10);   # Start casting spell every 10 seconds
        quest::settimer("minion_check", 1);  # Start checking health every second
    } elsif ($combat_state == 0) {  # Combat ended
        quest::stoptimer("spell_cast");
        quest::stoptimer("minion_check");
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cast") {
        if (!$spell_casted) {
            quest::castspell(40649, $npc->GetID());  # Cast the spell (ID 40649)
            $spell_casted = 1;
        }
    }

    if ($timer eq "minion_check") {
        my $hp_ratio = $npc->GetHPRatio();

        # Trigger shout and 75% max HP damage when health ≤ 80%
        if ($hp_ratio <= 80 && !$damage_applied) {
            my $hate_target = $npc->GetHateTop();
            if ($hate_target) {
                my $target_name = $hate_target->GetCleanName();
                quest::shout("$target_name! Let's see how you handle THIS!");

                # Deal 75% of the target's max HP as damage
                my $target_max_hp = $hate_target->GetMaxHP();
                my $damage = int($target_max_hp * 0.75);
                $hate_target->Damage($npc, $damage, 0, 0, 0, 0, true);

                $damage_applied = 1;
            }
        }

        # Spell + ranged immunity phase at ≤ 25% HP
        if ($hp_ratio <= 25 && !$minions_spawned) {
            $npc->ModifyNPCStat("special_abilities", "20,1^46,1");
            $npc->ModifyNPCStat("avoidance", "50");
            quest::shout("Your magic and arrows can no longer touch me!");
        }

        # Summon minions by HP thresholds
        if ($hp_ratio <= 25 && $minions_spawned < 3) {
            Summon_Minions(3);
            $minions_spawned = 3;
        } elsif ($hp_ratio <= 50 && $hp_ratio > 25 && $minions_spawned < 2) {
            Summon_Minions(2);
            $minions_spawned = 2;
        } elsif ($hp_ratio <= 75 && $hp_ratio > 50 && $minions_spawned < 1) {
            Summon_Minions(1);
            $minions_spawned = 1;
        }
    }
}

sub Summon_Minions {
    my ($count) = @_;
    quest::shout("Minions, assist me in battle!");
    for (my $i = 0; $i < $count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(1847, 0, 0, $x, $y, $z, $npc->GetHeading());
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Hahahaha! As always, we will meet again!");
    quest::stoptimer("spell_cast");
    quest::stoptimer("minion_check");
    quest::depop(1846);
}