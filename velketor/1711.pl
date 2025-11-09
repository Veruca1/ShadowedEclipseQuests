# ===========================================================
# Velketor_the_Sorcerer.pl — Boss Spawn Logic
# Shadowed Eclipse Velious Tier Scaling
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # Spawn NPC ID 1713 at the specified location
    quest::spawn2(1713, 0, 0, 170.11, 194.06, -56.53, 313.25);

    # === Apply Boss Baseline Stats (from velketor/default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 60);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 1200000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 6000);
    $npc->ModifyNPCStat("max_hit", 7000);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # === Resist and Attribute Setup ===
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

    # === Behavior Flags ===
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");

    # === Apply RaidScaling for adaptive tuning ===
    plugin::RaidScaling($entity_list, $npc);

    # Ensure full health after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { 
        # Start timers when combat begins
        quest::settimer("random_spell", 60);    # Random spell every 1 minute
        quest::settimer("spawn_minions", 50); # Spawn minions every 50 seconds
        quest::settimer("check_minions", 10);  # Check minions every 10 seconds
        quest::settimer("soul_drain", 60);     # Soul Drain every 1 minute
    } else { 
        # Stop all timers when combat ends
        quest::stoptimer("random_spell");
        quest::stoptimer("spawn_minions");
        quest::stoptimer("check_minions");
        quest::stoptimer("soul_drain");
        $npc->ModSkillDmgTaken(-1, 0); # Restore vulnerability
    }
}

sub EVENT_TIMER {
    if ($timer eq "random_spell") {
        # Cast random spell on target
        my $random_spell = quest::ChooseRandom(40607, 40606);
        $npc->CastSpell($random_spell, $npc->GetTarget()->GetID());
    } elsif ($timer eq "spawn_minions") {
        # Spawn minions around Velketor
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();        
        quest::spawn2(1683, 0, 0, $x - 5, $y - 5, $z, $h);
    } elsif ($timer eq "check_minions") {
        # Check for minions and toggle Velketor's invulnerability
        my @minions = $entity_list->GetNPCList();
        my $minion_found = 0;

        foreach my $npc (@minions) {
            if ($npc->GetNPCTypeID() == 1683) {
                $minion_found = 1;
                last;
            }
        }

        if ($minion_found) {
            $npc->ModSkillDmgTaken(-1, -100); # Make invulnerable
        } else {
            $npc->ModSkillDmgTaken(-1, 0);    # Remove invulnerability
        }
    } elsif ($timer eq "soul_drain") {
        # Perform Velketor's Soul Drain
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;  # Radius in units around Velketor

        # Message indicating the Soul Drain
        quest::shout("Your life force is mine, mortals! Feel the wrath of Velketor's sorcery!");

        # Damage all players within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 20000, 0, 1, false); # False to prevent hate list modification
            }
        }

        # Damage all bots within the radius
        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, 20000, 0, 1, false);
            }
        }

        # Damage all pets within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 20000, 0, 1, false);
                }
            }
        }

        # Damage all bot pets within the radius
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 20000, 0, 1, false);
                }
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Depop NPC ID 1713 if it exists
    my $npc_to_depop = $entity_list->GetNPCByNPCTypeID(1713);
    if ($npc_to_depop) {
        $npc_to_depop->Depop();
    }
}
