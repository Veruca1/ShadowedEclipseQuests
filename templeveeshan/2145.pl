# Veridian_Frostbane,_the_Eternal_Warden UD

sub EVENT_SPAWN {
    return unless $npc;
    quest::signalwith(1911, 899);

    # === Baseline ToV Boss Stats ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 63);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 17500000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 9500);
    $npc->ModifyNPCStat("max_hit", 11500);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # === Attribute & Resist Setup ===
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

    # === Immunities and Behavior ===
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # === Raid Scaling Integration ===
    plugin::RaidScaling($entity_list, $npc);

    # === Set HP to Max ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("life_drain", 38);
    } elsif ($combat_state == 0) {
        quest::stoptimer("life_drain");
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;

        # Damage clients
        foreach my $client ($entity_list->GetClientList()) {
            if ($client->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $client->Damage($npc, 35000, 0, 1, false);
            }

            # Damage their pets
            my $pet = $client->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, 35000, 0, 1, false);
            }
        }

        # Damage bots
        foreach my $bot ($entity_list->GetBotList()) {
            if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $bot->Damage($npc, 35000, 0, 1, false);
            }

            # Damage their pets
            my $pet = $bot->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, 35000, 0, 1, false);
            }
        }
    }
}

sub EVENT_DAMAGE_TAKEN {
    my ($attacker, $damage) = @_;
    return $damage;
}

sub EVENT_DEATH_COMPLETE {
    quest::spawn2(1595, 0, 0, -1166.82, 1861.11, 169.18, 387.75);
    quest::spawn2(1594, 0, 0, -1175.27, 1800.26, 170.36, 388.50);
    quest::spawn2(1595, 0, 0, -1172.91, 1740.11, 167.41, 389.75);
}