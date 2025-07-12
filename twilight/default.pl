sub EVENT_SPAWN {
    return unless $npc;

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;

    my %exclusion_list = (
        # your long list...
        map { $_ => 1 } (2000000..2000017, 2167)
    );
    return if exists $exclusion_list{$npc_id};
    return if $npc->IsPet();

    $is_boss = ($raw_name =~ /^#/ || ($npc_id == 1919 && $npc_id != 1974)) ? 1 : 0;

    $npc->SetNPCFactionID(623);
    $wrath_triggered = 0;

    if ($is_boss) {
        # ✅ Boss stat block
        $npc->ModifyNPCStat("level", 65);
        $npc->ModifyNPCStat("ac", 30000);
        $npc->ModifyNPCStat("max_hp", 55500000);
        $npc->ModifyNPCStat("hp_regen", 1000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 12000);
        $npc->ModifyNPCStat("max_hit", 30000);
        $npc->ModifyNPCStat("atk", 1400);
        $npc->ModifyNPCStat("accuracy", 2000);
        $npc->ModifyNPCStat("avoidance", 110);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 90);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 33);
        $npc->ModifyNPCStat("aggro", 60);
        $npc->ModifyNPCStat("assist", 1);

        $npc->ModifyNPCStat("str", 1200);
        $npc->ModifyNPCStat("sta", 1200);
        $npc->ModifyNPCStat("agi", 1200);
        $npc->ModifyNPCStat("dex", 1200);
        $npc->ModifyNPCStat("wis", 1200);
        $npc->ModifyNPCStat("int", 1200);
        $npc->ModifyNPCStat("cha", 1000);

        $npc->ModifyNPCStat("mr", 500);
        $npc->ModifyNPCStat("fr", 500);
        $npc->ModifyNPCStat("cr", 500);
        $npc->ModifyNPCStat("pr", 500);
        $npc->ModifyNPCStat("dr", 500);
        $npc->ModifyNPCStat("corruption_resist", 500);
        $npc->ModifyNPCStat("physical_resist", 1000);

        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1");

        for my $i (1..2) {
            my $rand = int(rand(90)) + 10; # random 10–100 sec
            quest::settimer("call_for_help_$i", $rand);
        }

        for my $i (1..2) {
            my $rand = int(rand(90)) + 10;
            quest::settimer("cleanse_all_$i", $rand);
        }

    } else {
        # ✅ Non-boss stat block
        $npc->ModifyNPCStat("level", 62);
        $npc->ModifyNPCStat("ac", 20000);
        $npc->ModifyNPCStat("max_hp", 15000000);
        $npc->ModifyNPCStat("hp_regen", 1000);
        $npc->ModifyNPCStat("mana_regen", 10000);
        $npc->ModifyNPCStat("min_hit", 10000);
        $npc->ModifyNPCStat("max_hit", 20000);
        $npc->ModifyNPCStat("atk", 1200);
        $npc->ModifyNPCStat("accuracy", 1800);
        $npc->ModifyNPCStat("avoidance", 100);
        $npc->ModifyNPCStat("attack_delay", 4);
        $npc->ModifyNPCStat("attack_speed", 100);
        $npc->ModifyNPCStat("slow_mitigation", 80);
        $npc->ModifyNPCStat("attack_count", 100);
        $npc->ModifyNPCStat("heroic_strikethrough", 23);
        $npc->ModifyNPCStat("aggro", 55);
        $npc->ModifyNPCStat("assist", 1);

        $npc->ModifyNPCStat("str", 1000);
        $npc->ModifyNPCStat("sta", 1000);
        $npc->ModifyNPCStat("agi", 1000);
        $npc->ModifyNPCStat("dex", 1000);
        $npc->ModifyNPCStat("wis", 1000);
        $npc->ModifyNPCStat("int", 1000);
        $npc->ModifyNPCStat("cha", 800);

        $npc->ModifyNPCStat("mr", 300);
        $npc->ModifyNPCStat("fr", 300);
        $npc->ModifyNPCStat("cr", 300);
        $npc->ModifyNPCStat("pr", 300);
        $npc->ModifyNPCStat("dr", 300);
        $npc->ModifyNPCStat("corruption_resist", 300);
        $npc->ModifyNPCStat("physical_resist", 800);

        $npc->ModifyNPCStat("runspeed", 2);
        $npc->ModifyNPCStat("trackable", 1);
        $npc->ModifyNPCStat("see_invis", 1);
        $npc->ModifyNPCStat("see_invis_undead", 1);
        $npc->ModifyNPCStat("see_hide", 1);
        $npc->ModifyNPCStat("see_improved_hide", 1);

        $npc->ModifyNPCStat("special_abilities", "3,1^5,1^7,1^8,1^9,1^10,1^14,1");
    }

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer =~ /^call_for_help_\d+$/ && $is_boss) {
        quest::stoptimer($timer);
        return unless $npc->IsEngaged();

        quest::shout("Surrounding minions of the twilight, arise and assist me!");
        my $top = $npc->GetHateTop();
        return unless $top;

        foreach my $mob ($entity_list->GetNPCList()) {
            next unless $mob && $mob->GetID() != $npc->GetID();
            my $dist = $npc->CalculateDistance($mob);
            $mob->AddToHateList($top, 1) if defined $dist && $dist <= 300;
        }
    }

    if ($timer =~ /^cleanse_all_\d+$/ && $is_boss) {
        quest::stoptimer($timer);
        return unless $npc->IsEngaged();

        $npc->BuffFadeAll();
        quest::shout("I shed all magic upon me! None shall bind me!");
    }

    if ($timer eq "life_drain" && $is_boss) {
        my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
        return unless defined $x && defined $y && defined $z;
        my $radius = 50;
        my $dmg = 6000;

        foreach my $c ($entity_list->GetClientList()) {
            next unless $c && $c->CalculateDistance($x, $y, $z) <= $radius;
            $c->Damage($npc, $dmg, 0, 1, false);
        }

        foreach my $b ($entity_list->GetBotList()) {
            next unless $b && $b->CalculateDistance($x, $y, $z) <= $radius;
            $b->Damage($npc, $dmg, 0, 1, false);
        }
    }
}

sub EVENT_COMBAT {
    return unless $npc;
    if ($combat_state == 1) {
        quest::settimer("life_drain", 5) if $is_boss;
    } else {
        quest::stoptimer("life_drain") if $is_boss;
    }
}

sub EVENT_DAMAGE_TAKEN {
    return unless $npc;

    my %excluded_pet_npc_ids = (
        500 => 1, 857 => 1, 681 => 1, 679 => 1, 776 => 1,
        map { $_ => 1 } (2000000..2000017)
    );

    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;

        if (quest::ChooseRandom(1..100) <= 20) {
            $npc->Shout("The Wrath of Luclin is unleashed!");

            my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
            my $radius = 50;
            my $dmg = 40000;

            foreach my $e ($entity_list->GetClientList()) {
                next unless $e;
                $e->Damage($npc, $dmg, 0, 1, false) if $e->CalculateDistance($x, $y, $z) <= $radius;

                my $pet = $e->GetPet();
                if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                    next if $excluded_pet_npc_ids{$pet->GetNPCTypeID()};
                    $pet->Damage($npc, $dmg, 0, 1, false);
                }
            }

            foreach my $b ($entity_list->GetBotList()) {
                next unless $b;
                $b->Damage($npc, $dmg, 0, 1, false) if $b->CalculateDistance($x, $y, $z) <= $radius;

                my $pet = $b->GetPet();
                if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                    next if $excluded_pet_npc_ids{$pet->GetNPCTypeID()};
                    $pet->Damage($npc, $dmg, 0, 1, false);
                }
            }
        }
    }

    return $damage;
}

sub EVENT_DEATH_COMPLETE {
    return unless $npc;

    my %exclusion_list = (
        153095 => 1, 1986 => 1, 1984 => 1, 1922 => 1, 1954 => 1, 1974 => 1,
        1992 => 1, 1936 => 1, 1921 => 1, 1709 => 1, 1568 => 1, 1831 => 1,
        857 => 1, 681 => 1, 679 => 1, 776 => 1,
    );

    my $npc_id = $npc->GetNPCTypeID() || 0;
    return if exists $exclusion_list{$npc_id};

    if (quest::ChooseRandom(1..100) <= 10) {
        my ($x, $y, $z, $h) = ($npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        quest::spawn2(1984, 0, 0, $x, $y, $z, $h);
    }
}