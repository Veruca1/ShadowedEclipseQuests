# ===========================================================
# The_Goomeninominon
# Shadowed Eclipse — Necropolis Boss Scaling
# - Applies boss baseline stats
# - Uses RaidScaling for adaptive group power adjustment
# - Includes randomized item add logic (as provided)
# ===========================================================

sub EVENT_SPAWN {
    return unless $npc;

    # === Randomized Item Add Logic ===
    my @item_list = (744, 745);

    # Shuffle the item list to ensure randomness without duplicates
    my @shuffled = sort { rand() <=> rand() } @item_list;

    # Always add 1 item
    $npc->AddItem($shuffled[0]);

    # 25% chance to add a second item
    if (int(rand(100)) < 25) {
        $npc->AddItem($shuffled[1]);
    }

    # 10% chance to add a third item
    if (int(rand(100)) < 10 && defined $shuffled[2]) {
        $npc->AddItem($shuffled[2]);
    }

    # === Boss Baseline Stats (from Necropolis default.pl) ===
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 25000);
    $npc->ModifyNPCStat("max_hp", 2000000);
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

sub EVENT_HP { 
    if ($npc->GetHPRatio() <= 50) {
        quest::modifynpcstat("special_abilities", "46,1");
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Engaged in combat
	quest::shout("I'm going to serve exactly what you are.....");
        quest::settimer("cast_spell", 50);  # Every 50 seconds
        quest::settimer("life_drain", 45);  # Every 45 seconds
        quest::settimer("drain_message", 45);  # Every 20 seconds

        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Hope you don’t mind a little mess, it's about to get real gooey in here!");
        }
    } 
    elsif ($combat_state == 0) {  # Out of combat
        quest::stoptimer("cast_spell");
        quest::stoptimer("life_drain");
        quest::stoptimer("drain_message");
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_spell") {
        my $target = $npc->GetHateTop();  
        if ($target) {
            my @shouts = (
                "Hit it like rom-pom-pom-pom!", 
                "Get it hot like Papa John!", 
                "Make a Goo go on and on!", 
                "It’s a Goomeninominon!", 
                "Knee deep in the passenger side and you're..."
            );

            my $random_shout = $shouts[int(rand(@shouts))];  
            quest::shout($random_shout);  

            my @clients = $entity_list->GetClientList();
            foreach my $client (@clients) {
                # Get the NPC's current position
                my $npc_x = $npc->GetX();
                my $npc_y = $npc->GetY();
                my $npc_z = $npc->GetZ();

                # Get the client's position
                my $client_x = $client->GetX();
                my $client_y = $client->GetY();
                my $client_z = $client->GetZ();

                # Calculate the distance between the NPC and the client in XYZ coordinates
                my $distance = sqrt(($npc_x - $client_x)**2 + ($npc_y - $client_y)**2 + ($npc_z - $client_z)**2);

                # Define a maximum range for the spell (e.g., 100 units)
                my $max_range = 100;

                # Check if the client is within range
                if ($distance <= $max_range) {
                    $npc->CastSpell(40633, $client->GetID());  # Cast on the client

                    my $pet = $client->GetPet();
                    if ($pet) {
                        $npc->CastSpell(40633, $pet->GetID());  # Cast on the player's pet if it exists
                    }
                }
            }
        }
    }

    if ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;  

        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 15000, 0, 1, false);
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, 15000, 0, 1, false);
            }
        }

        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 15000, 0, 1, false);
                }
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 15000, 0, 1, false);
                }
            }
        }
    }

    if ($timer eq "drain_message") {
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Hope you don’t mind a little mess, it's about to get real gooey in here!");
        }

        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "Hope you don’t mind a little mess, it's about to get real gooey in here!");
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("I still got the job done!");  
}
