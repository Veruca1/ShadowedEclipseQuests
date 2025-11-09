# ===========================================================
# 1731.pl — Envoy_of_Nyseria
# Shadowed Eclipse Velious Tier Boss
# - Applies tuned boss baseline stats
# - Periodically checks buffs
# - Spawns Nyseria's minions once per encounter
# - Uses RaidScaling for adaptive group scaling
# ===========================================================

my $minions_spawned = 0;

sub EVENT_SPAWN {
    return unless $npc;

    # === Boss Baseline Stats (matching sirens/default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 60);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 10000000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 7500);
    $npc->ModifyNPCStat("max_hit", 8500);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("attack_delay", 6);
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

    # === Abilities and Visibility ===
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");

    # === Set HP to Max after stat modifications ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === Begin Buff Check Timer ===
    quest::settimer("check_buffs", 1);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("life_drain", 15);       # Life drain now triggers every 15 seconds
        quest::settimer("spell_cast", 30);      # Spell cast timer
        quest::settimer("minion_check", 1);     # Minion logic
        quest::settimer("check_hp", 1);         # Health-based immunity logic
        
        # Display message only once when combat begins
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "A chilling darkness spreads as the Envoy of Nyseria begins to sap your life force!");
        }
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "A chilling darkness spreads as the Envoy of Nyseria begins to sap your life force!");
        }
    } elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("life_drain");         # Stop life drain
        quest::stoptimer("spell_cast");         # Stop spell casting
        quest::stoptimer("minion_check");       # Stop minion logic
        quest::stoptimer("check_hp");           # Stop health checks
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        $npc->CastSpell(12879, $npc->GetID()) if !$npc->FindBuff(12879);
    }

    if ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;  # Radius in units around the NPC

        # Drain 1000 HP from players, bots, and their pets within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 1000, 0, 1, false); # False to avoid hate modification
            }
            # Drain from pets of the client
            my $pet = $entity->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, 1000, 0, 1, false);
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, 1000, 0, 1, false);
            }
            # Drain from pets of the bot
            my $pet = $bot->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, 1000, 0, 1, false);
            }
        }
    }

    if ($timer eq "spell_cast") {
        $npc->CastSpell(40604, $npc->GetID());
        $npc->Attack($npc->GetHateTop());  # Re-engage attack after casting
    }

    if ($timer eq "minion_check") {
        my $hp_ratio = $npc->GetHPRatio();

        # Summon 3 minions at each health threshold
        if ($hp_ratio <= 75 && $minions_spawned < 1) {
            Summon_Minions(3);
            $minions_spawned = 1;
        } elsif ($hp_ratio <= 50 && $minions_spawned < 2) {
            Summon_Minions(3);
            $minions_spawned = 2;
        } elsif ($hp_ratio <= 25 && $minions_spawned < 3) {
            Summon_Minions(3);
            $minions_spawned = 3;
        }
    }

    if ($timer eq "check_hp") {
        # Check if NPC's health is at or below 50%
        if ($npc->GetHPRatio() <= 50) {
            # Make the NPC immune to ranged and magic attacks
            $npc->SetSpecialAbility(46, 1); # Ranged immunity            
            # Stop further checks to prevent re-triggering
            quest::stoptimer("check_hp");
        }
    }
}

sub Summon_Minions {
    my ($count) = @_;
    for (my $i = 0; $i < $count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(1733, 0, 0, $x, $y, $z, $npc->GetHeading());
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("life_drain");
    quest::stoptimer("spell_cast");
    quest::stoptimer("minion_check");
    quest::stoptimer("check_hp");
}
