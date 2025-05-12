my $wrath_triggered = 0;
my $is_boss = 0;

sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id = $npc->GetNPCTypeID();

    # Exclusion list
    my %exclusion_list = (
        156055 => 1,
    );
    return if exists $exclusion_list{$npc_id};
    return if $npc->IsPet();

    $is_boss = ($raw_name =~ /^#/ || $npc_id == 1919) ? 1 : 0;

    my %base_stats = (
        ac                   => 11000, 
        max_hp               => 1100000,     
        min_hit              => 6000,   
        max_hit              => 7500,
        accuracy             => 1800,
        avoidance            => 80,    
        slow_mitigation      => 80,
        attack               => 1200, 
        str                  => 1000,
        sta                  => 1000,
        dex                  => 1000,
        agi                  => 1000,
        int                  => 1000,
        wis                  => 1000,
        cha                  => 800,
        physical_resist      => 800,
        hp_regen_rate        => 800,
        hp_regen_per_second  => 400,
        special_attacks      => "3,1^5,1^6,1^14,1^17,1^21,1",
    );

    my %boss_stats = (
        ac                   => 15000, 
        max_hp               => 2500000,     
        min_hit              => 7000,   
        max_hit              => 8500,
        accuracy             => 2000,
        avoidance            => 90,    
        slow_mitigation      => 90,
        attack               => 1400, 
        str                  => 1200,
        sta                  => 1200,
        dex                  => 1200,
        agi                  => 1200,
        int                  => 1200,
        wis                  => 1200,
        cha                  => 1000,
        physical_resist      => 1000,
        hp_regen_rate        => 1000,
        hp_regen_per_second  => 500,
        special_attacks      => "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1",
    );

    my %stats_to_apply = $is_boss ? (%boss_stats) : (%base_stats);

    foreach my $key (keys %stats_to_apply) {
        $npc->ModifyNPCStat($key, $stats_to_apply{$key});
    }

    # Set level and reset HP
    $npc->SetLevel(61);
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    quest::setnexthpevent(50) if $is_boss;  # Set HP event for bosses only

    $wrath_triggered = 0;
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
        156055 => 1,
        1922   => 1,
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