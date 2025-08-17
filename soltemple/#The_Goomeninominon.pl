sub EVENT_SPAWN {
    return unless $npc;

    my $npc_id = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 100000000); 
    $npc->ModifyNPCStat("hp_regen", 500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 28000);
    $npc->ModifyNPCStat("max_hit", 73000);
    $npc->ModifyNPCStat("atk", 1500);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 20);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    $npc->SetHP($npc->GetMaxHP());
    $npc->SetNPCTintIndex(30);
    $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

    quest::set_data("mirror_spellset", "40786,40787");
    quest::settimer("cast_cycle", 20);

    $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);

    my $base_name = $npc->GetCleanName();
    my $title_tag = "the Reflected";
    my $new_name  = ($base_name =~ /\bReflected\b/i) ? $base_name : "$base_name $title_tag";
    $npc->TempName($new_name);
    $npc->ModifyNPCStat("lastname", "Reflected");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::shout("Time to give you everything you asked for...");
        quest::settimer("cast_spell", 50);
        quest::settimer("life_drain", 45);
        quest::settimer("drain_message", 45);

        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Oh honey, you're about to meet The Giver. Hope you can handle devotion turned deadly.");
        }
    } 
    elsif ($combat_state == 0) {
        quest::stoptimer("cast_spell");
        quest::stoptimer("life_drain");
        quest::stoptimer("drain_message");
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_cycle") {
        my $data = quest::get_data("mirror_spellset") || "";
        my @spells = split(/,/, $data);
        return unless @spells;

        my $spell_id = $spells[int(rand(@spells))];
        my $target = $npc->GetHateRandom();
        $npc->CastSpell($spell_id, $target->GetID()) if $target;
    }

    if ($timer eq "cast_spell") {
        my $target = $npc->GetHateTop();  
        if ($target) {
            my @shouts = (
                "You wanted it all—so take it!",
                "Bleed for the love you begged for!",
                "This is how devotion destroys.",
                "Call me The Giver, baby, and I never stop.",
                "You're not ready for the kind of love I am."
            );

            my $random_shout = $shouts[int(rand(@shouts))];  
            quest::shout($random_shout);  

            my @clients = $entity_list->GetClientList();
            foreach my $client (@clients) {
                my $npc_x = $npc->GetX();
                my $npc_y = $npc->GetY();
                my $npc_z = $npc->GetZ();

                my $client_x = $client->GetX();
                my $client_y = $client->GetY();
                my $client_z = $client->GetZ();

                my $distance = sqrt(($npc_x - $client_x)**2 + ($npc_y - $client_y)**2 + ($npc_z - $client_z)**2);
                my $max_range = 100;

                if ($distance <= $max_range) {
                    $npc->CastSpell(40126, $client->GetID());

                    my $pet = $client->GetPet();
                    if ($pet) {
                        $npc->CastSpell(40126, $pet->GetID());
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
                $entity->Damage($npc, 100000, 0, 1, false);
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, 100000, 0, 1, false);
            }
        }

        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 100000, 0, 1, false);
                }
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 100000, 0, 1, false);
                }
            }
        }
    }

    if ($timer eq "drain_message") {
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "You wanted everything—I’ll leave you with nothing.");
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Hahahaha! She got, she got away, she got away, she got away!");
}