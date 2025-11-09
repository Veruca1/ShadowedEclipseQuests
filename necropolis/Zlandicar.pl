# ===========================================================
# Zlandicar (1813)
# Shadowed Eclipse — Necropolis Boss Scaling
# - Applies boss baseline stats
# - Uses RaidScaling for adaptive group power adjustment
# - Includes marquee intro message (as provided)
# ===========================================================

sub EVENT_SPAWN {   
    return unless $npc;

    # === Camera and Marquee Intro ===
    $npc->CameraEffect(1000, 3);

    my @clients = $entity_list->GetClientList();
    my $text = "You feel a disturbance and great evil to the west.";

    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);
    }

    # === Boss Baseline Stats (from Necropolis default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 25000);
    $npc->ModifyNPCStat("max_hp", 10000000);
    $npc->ModifyNPCStat("hp_regen", 3200);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 9800);
    $npc->ModifyNPCStat("max_hit", 13000);
    $npc->ModifyNPCStat("atk", 1450);
    $npc->ModifyNPCStat("accuracy", 1220);
    $npc->ModifyNPCStat("avoidance", 55);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("heroic_strikethrough", 10);
    $npc->ModifyNPCStat("slow_mitigation", 85);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    # === Core Attributes ===
    $npc->ModifyNPCStat("str", 1150);
    $npc->ModifyNPCStat("sta", 1150);
    $npc->ModifyNPCStat("agi", 1150);
    $npc->ModifyNPCStat("dex", 1150);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 850);

    # === Resistances ===
    $npc->ModifyNPCStat("mr", 280);
    $npc->ModifyNPCStat("fr", 280);
    $npc->ModifyNPCStat("cr", 280);
    $npc->ModifyNPCStat("pr", 280);
    $npc->ModifyNPCStat("dr", 280);
    $npc->ModifyNPCStat("corruption_resist", 260);
    $npc->ModifyNPCStat("physical_resist", 675);

    # === Special Abilities ===
    $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^12,1");

    # === Apply Raid Scaling ===
    plugin::RaidScaling($entity_list, $npc);

    # === Reset HP to Full ===
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp > 0;
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { 
        # Combat starts
        quest::shout("Foolish mortals, you dare trespass in my lair? Your bones will join my collection!");

        # Cast spell 13421 on all players, bots, and pets in the zone
        my @clients = $entity_list->GetClientList();
        foreach my $client (@clients) {
            $npc->CastSpell(13421, $client->GetID());  # Cast on each player
            my $pet = $client->GetPet();
            if ($pet) {
                $npc->CastSpell(13421, $pet->GetID());  # Cast on the player's pet if it exists
            }
        }

        # Cast on bots
        my @bots = $entity_list->GetBotList();
        foreach my $bot (@bots) {
            $npc->CastSpell(13421, $bot->GetID());  # Cast on each bot
            my $bot_pet = $bot->GetPet();
            if ($bot_pet) {
                $npc->CastSpell(13421, $bot_pet->GetID());  # Cast on the bot's pet if it exists
            }
        }

        # Start the life drain damage effect when the fight begins
        quest::settimer("life_drain", 10);  # Set the timer for life drain every 10 seconds
    } elsif ($combat_state == 0) { 
        # Combat ends
        quest::shout("You have merely delayed the inevitable... my hunger is eternal...");
        
        # Stop the life drain effect when the fight ends
        quest::stoptimer("life_drain");  # Stop the timer for life drain
    }
}

sub EVENT_HEALTH {
    if ($npc->GetHealthPercent() <= 50) {
        # Set immunity to ranged attacks (ID 46) with flag 1
        $npc->SetSpecialAbility(46, 1); # 46 is the ability ID, 1 is the value for immunity
    } else {
        # Remove immunity to ranged attacks if health is above 50%
        $npc->SetSpecialAbility(46, 0); # Set to 0 to remove the immunity
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        # Apply the life drain effect (damage) to all players and bots in the vicinity
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 100;  # Updated radius to 100 units

        # Drain 5000 HP from players within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 5000, 0, 1, false); # Apply 5000 damage, no hate modification
            }
        }

        # Drain 5000 HP from bots within the radius
        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, 5000, 0, 1, false); # Apply 5000 damage to bot
            }
        }

        # Drain 5000 HP from pets within the radius
        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet(); # Get the pet of the player
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 5000, 0, 1, false); # Apply 5000 damage to the pet
                }
            }
        }

        # Drain 5000 HP from bot pets within the radius
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet(); # Get the pet of the bot
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 5000, 0, 1, false); # Apply 5000 damage to the pet
                }
            }
        }
    }
}
