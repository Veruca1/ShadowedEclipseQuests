sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID();

    # Exclusion list: skip certain NPC IDs and pets
    my %exclusion_list = (
        153095 => 1,
        857 => 1,
        681 => 1,
        679 => 1,
        776 => 1,
        map { $_ => 1 } (2000000..2000017)
    );
    return if exists $exclusion_list{$npc_id};
    return if $npc->IsPet();

    # Determine if it's a boss: name starts with '#' or specific NPC ID
    my $is_boss = ($raw_name =~ /^#/ || $npc_id == 1919) ? 1 : 0;

    # Set to non-KOS faction
    $npc->SetNPCFactionID(623); # Ensure faction 1 is set to non-KOS in DB

    my $wrath_triggered = 0; # Local variable to track HP event usage

    if ($is_boss) {
        # Boss stats
        $npc->ModifyNPCStat("str", 1200);
        $npc->ModifyNPCStat("sta", 1200);
        $npc->ModifyNPCStat("agi", 1200);
        $npc->ModifyNPCStat("dex", 1200);
        $npc->ModifyNPCStat("wis", 1200);
        $npc->ModifyNPCStat("int", 1200);
        $npc->ModifyNPCStat("cha", 1000);

        $npc->ModifyNPCStat("ac", 20000);
        $npc->ModifyNPCStat("mr", 500);
        $npc->ModifyNPCStat("fr", 500);
        $npc->ModifyNPCStat("cr", 500);
        $npc->ModifyNPCStat("pr", 500);
        $npc->ModifyNPCStat("dr", 500);
        $npc->ModifyNPCStat("corruption_resist", 500);
        $npc->ModifyNPCStat("physical_resist", 1000);

        $npc->ModifyNPCStat("max_hp", 10500000);
        #$npc->ModifyNPCStat("max_mana", 10000);
        $npc->ModifyNPCStat("hp_regen", 1000);
        $npc->ModifyNPCStat("mana_regen", 10000);

        $npc->ModifyNPCStat("min_hit", 8500);
        $npc->ModifyNPCStat("max_hit", 13000);
        $npc->ModifyNPCStat("atk", 1400);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 90);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 30);

        # Optional spell configs
        #$npc->ModifyNPCStat("npc_spells_id", 1);
        #$npc->ModifyNPCStat("npc_spells_effects_id", 1);
        #$npc->ModifyNPCStat("spellscale", 1);
        #$npc->ModifyNPCStat("healscale", 1);

        $npc->ModifyNPCStat("level", 63);
        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("aggro", 60);
        $npc->ModifyNPCStat("assist", 1);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        # Special attacks: flurry, rampage, etc.
        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1");

        # HP event for boss
        quest::setnexthpevent(50);
    }
    else {
        # Trash mob stats
        $npc->ModifyNPCStat("str", 1000);
        $npc->ModifyNPCStat("sta", 1000);
        $npc->ModifyNPCStat("agi", 1000);
        $npc->ModifyNPCStat("dex", 1000);
        $npc->ModifyNPCStat("wis", 1000);
        $npc->ModifyNPCStat("int", 1000);
        $npc->ModifyNPCStat("cha", 800);

        $npc->ModifyNPCStat("ac", 15000);
        $npc->ModifyNPCStat("mr", 300);
        $npc->ModifyNPCStat("fr", 300);
        $npc->ModifyNPCStat("cr", 300);
        $npc->ModifyNPCStat("pr", 300);
        $npc->ModifyNPCStat("dr", 300);
        $npc->ModifyNPCStat("corruption_resist", 300);
        $npc->ModifyNPCStat("physical_resist", 800);

        $npc->ModifyNPCStat("max_hp", 4000000);
        #$npc->ModifyNPCStat("max_mana", 10000);
        $npc->ModifyNPCStat("hp_regen", 800);
        $npc->ModifyNPCStat("mana_regen", 10000);

        $npc->ModifyNPCStat("min_hit", 9200);
        $npc->ModifyNPCStat("max_hit", 11000);
        $npc->ModifyNPCStat("atk", 1200);
        $npc->ModifyNPCStat("accuracy", 1800);
        $npc->ModifyNPCStat("avoidance", 80);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 80);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 20);

        # Optional spell configs
        #$npc->ModifyNPCStat("npc_spells_id", 1);
        #$npc->ModifyNPCStat("npc_spells_effects_id", 1);
        #$npc->ModifyNPCStat("spellscale", 1);
        #$npc->ModifyNPCStat("healscale", 1);

        $npc->ModifyNPCStat("level", 61);
        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("aggro", 55);
        $npc->ModifyNPCStat("assist", 1);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        # Standard trash mob special attacks
        $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1^27,1");
    }

    # Reset HP to max
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_HP {
    return unless $is_boss;
    return unless $npc;

    if ($hpevent == 50) {
        quest::shout("Surrounding minions of the cavern, arise and assist me!");

        my $top_hate_target = $npc->GetHateTop();
        return unless $top_hate_target;

        my @npcs = $entity_list->GetNPCList();
        return unless @npcs;

        foreach my $mob (@npcs) {
            next unless $mob;
            next if $mob->GetID() == $npc->GetID();

            my $distance = $npc->CalculateDistance($mob);
            if (defined $distance && $distance <= 300) {
                $mob->AddToHateList($top_hate_target, 1);
            }
        }
    }
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        quest::settimer("silence_sk", 30);
        quest::settimer("life_drain", 5) if $is_boss;
    } else {
        quest::stoptimer("silence_sk");
        quest::stoptimer("life_drain") if $is_boss;

        # Only bosses re-arm HP event
        quest::settimer("reset_hp_event", 50) if $is_boss;
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "silence_sk") {
        my @hate_list = $npc->GetHateList();
        foreach my $hate_entry (@hate_list) {
            next unless $hate_entry;
            my $ent = $hate_entry->GetEnt();
            next unless $ent && $ent->IsClient();

            my $pc = $ent->CastToClient();
            if ($pc && $pc->GetClass() == 5) {
                $npc->CastSpell(12431, $pc->GetID());
                $npc->Shout("Your dark magic falters, Shadowknight!");
            }
        }
    }

    if ($timer eq "life_drain" && $is_boss) {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $radius = 50;
        my $drain_damage = 6000;

        foreach my $client ($entity_list->GetClientList()) {
            next unless $client;
            my $dist = $client->CalculateDistance($x, $y, $z);
            $client->Damage($npc, $drain_damage, 0, 1, false) if $dist <= $radius;
        }

        foreach my $bot ($entity_list->GetBotList()) {
            next unless $bot;
            my $dist = $bot->CalculateDistance($x, $y, $z);
            $bot->Damage($npc, $drain_damage, 0, 1, false) if $dist <= $radius;
        }
    }

    if ($timer eq "reset_hp_event" && $is_boss) {
        quest::setnexthpevent(50);
        quest::stoptimer("reset_hp_event");
    }
}

my $wrath_triggered = 0;

sub EVENT_DAMAGE_TAKEN {
    my $attacker = $entity_list->GetMobByID($clientid);
    if ($attacker && $attacker->IsClient()) {
        my $pc = $attacker->CastToClient();
        if ($pc->GetClass() == 5) {  # Shadowknight
            $damage = int($damage * 0.5);  # Reduce damage taken by 50%
        }
    }

    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;

        if (quest::ChooseRandom(1..100) <= 20) {
            $npc->Shout("The Wrath of Luclin is unleashed!");

            my $npc_x = $npc->GetX();
            my $npc_y = $npc->GetY();
            my $npc_z = $npc->GetZ();
            my $radius = 50;
            my $wrath_dmg = 35000;

            # Clients and their pets
            foreach my $entity ($entity_list->GetClientList()) {
                if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $entity->Damage($npc, $wrath_dmg, 0, 1, false);
                }

                my $pet = $entity->GetPet();
                if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $pet->Damage($npc, $wrath_dmg, 0, 1, false);
                }
            }

            # Bots and their pets
            foreach my $bot ($entity_list->GetBotList()) {
                if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $bot->Damage($npc, $wrath_dmg, 0, 1, false);
                }

                my $pet = $bot->GetPet();
                if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                    $pet->Damage($npc, $wrath_dmg, 0, 1, false);
                }
            }
        }
    }

    return $damage;
}

sub EVENT_DEATH_COMPLETE {
    return unless $npc;

    my %exclusion_list = (
        153095 => 1,
        1922   => 1,
        1954   => 1,
        857 => 1,
        681 => 1,
        679 => 1,
        776 => 1,
    );

    my $npc_id = $npc->GetNPCTypeID();
    return if exists $exclusion_list{$npc_id};

    if (quest::ChooseRandom(1..100) <= 10) {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();
        quest::spawn2(1922, 0, 0, $x, $y, $z, $h);
    }
}