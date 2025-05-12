my $wrath_triggered = 0;

sub EVENT_SPAWN {
    return unless $npc;
    return unless $npc->GetNPCTypeID() == 1919;

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
        special_attacks      => "3,1^5,1^6,1^14,1^17,1^21,1"
    );

    foreach my $key (keys %base_stats) {
        $npc->ModifyNPCStat($key, $base_stats{$key});
    }

    $npc->SetLevel(61);
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if $max_hp && $max_hp > 0;

    $wrath_triggered = 0;
}

sub EVENT_COMBAT {
    return unless $npc;
    return unless $npc->GetNPCTypeID() == 1919;

    if ($combat_state == 1) {
        quest::settimer("silence_sk", 30);
        quest::settimer("life_drain", 5);
    } else {
        quest::stoptimer("silence_sk");
        quest::stoptimer("life_drain");
    }
}

sub EVENT_TIMER {
    return unless $npc;
    return unless $npc->GetNPCTypeID() == 1919;

    if ($timer eq "silence_sk") {
        foreach my $hate_entry ($npc->GetHateList()) {
            next unless $hate_entry;
            my $ent = $hate_entry->GetEnt();
            next unless $ent && $ent->IsClient();
            my $pc = $ent->CastToClient();
            if ($pc && $pc->GetClass() == 5) {  # Shadowknight
                $npc->CastSpell(12431, $pc->GetID()); # Silence
                $npc->Shout("Your dark magic falters, Shadowknight!");
            }
        }
    }

    if ($timer eq "life_drain") {
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $radius = 50;
        my $drain_damage = 6000;

        foreach my $target ($entity_list->GetClientList(), $entity_list->GetBotList()) {
            next unless $target;
            my $dist = $target->CalculateDistance($x, $y, $z);
            $target->Damage($npc, $drain_damage, 0, 1, false) if $dist <= $radius;
        }
    }
}

sub EVENT_DAMAGE_TAKEN {
    return $damage unless $npc && $npc->GetNPCTypeID() == 1919;
    return $damage unless defined $clientid;

    my $attacker = $entity_list->GetMobByID($clientid);
    if ($attacker && $attacker->IsClient()) {
        my $pc = $attacker->CastToClient();
        $damage = int($damage * 0.5) if $pc && $pc->GetClass() == 5;  # Shadowknight
    }

    my $hp = $npc->GetHP();
    my $max_hp = $npc->GetMaxHP();
    if (!$wrath_triggered && $hp > 0 && $max_hp > 0 && $hp <= ($max_hp * 0.10)) {
        $wrath_triggered = 1;
        if (quest::ChooseRandom(1..100) <= 20) {
            $npc->Shout("The Wrath of Luclin is unleashed!");
            my $x = $npc->GetX();
            my $y = $npc->GetY();
            my $z = $npc->GetZ();
            my $radius = 50;
            my $wrath_dmg = 35000;

            foreach my $target ($entity_list->GetClientList(), $entity_list->GetBotList()) {
                my $dist = $target->CalculateDistance($x, $y, $z);
                $target->Damage($npc, $wrath_dmg, 0, 1, false) if $dist <= $radius;
                my $pet = $target->GetPet();
                if ($pet) {
                    my $pet_dist = $pet->CalculateDistance($x, $y, $z);
                    $pet->Damage($npc, $wrath_dmg, 0, 1, false) if $pet_dist <= $radius;
                }
            }
        }
    }

    return $damage;
}

sub EVENT_DEATH_COMPLETE {
    if (int(rand(100)) < 25) {
        quest::spawn2(1918, 0, 0, $x, $y, $z, $h);
    }
}