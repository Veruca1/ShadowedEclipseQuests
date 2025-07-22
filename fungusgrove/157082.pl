# 157082.pl

my $wrath_triggered = 0;

sub EVENT_SPAWN {
    return unless $npc;

    # ✅ Boss base stats
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 55500000);
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
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        # ✅ Signal the zone controller to stop rotation
        quest::signalwith(10, 911, 0);

        # ✅ Randomly set timers for help and cleanse
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
        # ✅ Stop all timers when out of combat
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

    } elsif ($timer =~ /^call_for_help_/) {
        quest::stoptimer($timer);

        return unless $npc->IsEngaged();
        quest::shout("Minions, to me! Aid your master!");

        my $top = $npc->GetHateTop();
        return unless $top;

        foreach my $mob ($entity_list->GetNPCList()) {
            next unless $mob && $mob->GetID() != $npc->GetID();
            my $dist = $npc->CalculateDistance($mob);
            $mob->AddToHateList($top, 1) if defined $dist && $dist <= 500;
        }

    } elsif ($timer =~ /^cleanse_debuff_/) {
        quest::stoptimer($timer);

        return unless $npc->IsEngaged();
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
    # Depop existing instance of 157089 if it exists to prevent duplicate spawns
    my $existing = $entity_list->GetNPCByNPCTypeID(157089);
    $existing->Depop(1) if $existing;

    # Spawn NPC ID 157089 at specified location
    quest::spawn2(157089, 0, 0, -1152.59, 225.47, -379.94, 503.75);
}