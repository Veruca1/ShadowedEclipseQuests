# ===========================================================
# #Geonid_Shepherd.pl — Wakening Lands
# Uses Wakening Lands default.pl boss baseline + RaidScaling
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Boss Baseline (from wakening default.pl) ===
    $npc->SetNPCFactionID(623);

    $npc->ModifyNPCStat("level", 60);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 2750000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 7700);
    $npc->ModifyNPCStat("max_hit", 8700);
    $npc->ModifyNPCStat("atk", 1200);
    $npc->ModifyNPCStat("accuracy", 1100);
    $npc->ModifyNPCStat("avoidance", 50);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 8);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 75);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    # Attributes / Resists (WL boss baseline)
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

    # Awareness / Flags (WL boss baseline)
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1");

    # === Apply Raid Scaling (same as default.pl) ===
    plugin::RaidScaling($entity_list, $npc);

    # Ensure full HP after scaling
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("life_drain", 35);      # Drain every 35 seconds
        quest::settimer("drain_message", 35);   # Message syncs with drain

        # Initial warning message
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "The earth rumbles as the Geonid Shepherd awakens, its presence crushing the very air around you!");
        }
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "The earth rumbles as the Geonid Shepherd awakens, its presence crushing the very air around you!");
        }
    } 
    elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("life_drain");        
        quest::stoptimer("drain_message");      
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;  # Effect range

        # Random damage between 10,000 and 20,000 HP
        my $damage_amount = plugin::RandomRange(10000, 20000); 

        # Apply damage to players and bots
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, $damage_amount, 0, 1, false);
            }
        }
        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, $damage_amount, 0, 1, false);
            }
        }

        # Apply damage to pets
        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, $damage_amount, 0, 1, false);
                }
            }
        }
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, $damage_amount, 0, 1, false);
                }
            }
        }
    }
    elsif ($timer eq "drain_message") {
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "The Geonid Shepherd lets out a deep, grinding growl as stone fractures and dust fills the air—your life force is slipping away!");
        }
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "The Geonid Shepherd lets out a deep, grinding growl as stone fractures and dust fills the air—your life force is slipping away!");
        }
    }
}