use List::Util qw(max);

my $is_boss = 1;
my $wrath_triggered = 0;
my $pet_npc_id;   # Stores the spawn2 ID of the pet
my $pet_npc_type = 2165;  # <-- Use your desired pet NPC type ID

sub EVENT_SPAWN {
    return unless $npc;

    # ✅ Boss base stats
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 15550000);
    $npc->ModifyNPCStat("hp_regen", 1000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 20000);
    $npc->ModifyNPCStat("max_hit", 40000);
    $npc->ModifyNPCStat("atk", 1400);
    $npc->ModifyNPCStat("accuracy", 2000);
    $npc->ModifyNPCStat("avoidance", 90);
    $npc->ModifyNPCStat("attack_delay", 6);
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

    $npc->ModifyNPCStat("mr", 300);
    $npc->ModifyNPCStat("fr", 300);
    $npc->ModifyNPCStat("cr", 300);
    $npc->ModifyNPCStat("pr", 300);
    $npc->ModifyNPCStat("dr", 300);
    $npc->ModifyNPCStat("corruption_resist", 500);
    $npc->ModifyNPCStat("physical_resist", 1000);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    $wrath_triggered = 0;

    # ✅ Ramp-up chain starts
    quest::setnexthpevent(75);

    # ✅ Spawn pet NPC at exact attached loc
    my ($x, $y, $z, $h) = (483.78, -1099.03, 131.97, 132.25);
    $pet_npc_id = quest::spawn2($pet_npc_type, 0, 0, $x, $y, $z, $h);
}

sub EVENT_HP {
    return unless $npc;

    if ($hpevent == 75) {
        quest::shout("You feel my anger rise — your blows only sharpen my blade!");
        $npc->ModifyNPCStat("min_hit", 25000);
        $npc->ModifyNPCStat("max_hit", 45000);
        $npc->ModifyNPCStat("atk", 1600);
        $npc->ModifyNPCStat("accuracy", 2200);
        $npc->ModifyNPCStat("avoidance", 95);
        quest::setnexthpevent(50);

    } elsif ($hpevent == 50) {
        quest::shout("My wrath deepens! You will break before I do!");
        $npc->ModifyNPCStat("min_hit", 30000);
        $npc->ModifyNPCStat("max_hit", 50000);
        $npc->ModifyNPCStat("atk", 1800);
        $npc->ModifyNPCStat("accuracy", 2400);
        $npc->ModifyNPCStat("avoidance", 100);
        quest::setnexthpevent(25);

    } elsif ($hpevent == 25) {
        quest::shout("This is my final stand — every strike lands true!");
        $npc->ModifyNPCStat("min_hit", 35000);
        $npc->ModifyNPCStat("max_hit", 60000);
        $npc->ModifyNPCStat("atk", 2000);
        $npc->ModifyNPCStat("accuracy", 2800);
        $npc->ModifyNPCStat("avoidance", 110);
    }
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        # ✅ Pet aggro logic: match boss target
        my $pet_npc = $entity_list->GetNPCByID($pet_npc_id);
        if ($pet_npc) {
            my $target = $npc->GetHateTop();
            if ($target) {
                $pet_npc->AddToHateList($target, 1);
            }
        }

        for my $i (1..2) {
            my $rand = int(rand(99)) + 1;
            quest::settimer("call_for_help_$i", $rand);
        }
        for my $i (1..2) {
            my $rand = int(rand(99)) + 1;
            quest::settimer("cleanse_debuff_$i", $rand);
        }

        quest::settimer("life_drain", 5);
    } else {
        # ✅ Clear pet aggro if combat ends
        my $pet_npc = $entity_list->GetNPCByID($pet_npc_id);
        $pet_npc->WipeHateList() if $pet_npc;

        for my $i (1..2) {
            quest::stoptimer("call_for_help_$i");
            quest::stoptimer("cleanse_debuff_$i");
        }
        quest::stoptimer("life_drain");
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "life_drain") {
        my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
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

    elsif ($timer =~ /^call_for_help_/) {
        quest::stoptimer($timer);

        if (!$npc->IsEngaged()) {
            plugin::Debug("[$timer] fired but boss not in combat, skipping help call.");
            return;
        }

        quest::shout("Minions, to me! Aid your master!");
        my $top = $npc->GetHateTop();
        return unless $top;

        foreach my $mob ($entity_list->GetNPCList()) {
            next unless $mob && $mob->GetID() != $npc->GetID();
            my $dist = $npc->CalculateDistance($mob);
            $mob->AddToHateList($top, 1) if defined $dist && $dist <= 500;
        }
    }

    elsif ($timer =~ /^cleanse_debuff_/) {
        quest::stoptimer($timer);

        if (!$npc->IsEngaged()) {
            plugin::Debug("[$timer] fired but boss not in combat, skipping debuff cleanse.");
            return;
        }

        # ✅ Unified: match default.pl — wipe ALL buffs
        $npc->BuffFadeAll();
        quest::shout("I shake off all magic!");
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