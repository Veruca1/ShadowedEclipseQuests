use List::Util qw(max);

my $is_boss = 1;
my $wrath_triggered = 0;

# ✅ Tint cycle setup — final chosen tints
my @tints = (10, 31, 33, 36);
# 10 = Fire, 31 = Earth, 33 = Wind, 36 = Ice
my %tint_to_item = (
    10 => 43643, # Fire Stabilization
    31 => 43640, # Earthen Stabilization
    33 => 43641, # Wind Stabilization
    36 => 43642, # Ice Stabilization
);
my %tint_names = (
    10 => "Fire!",
    31 => "Earth!",
    33 => "Air!",
    36 => "Water!"
);
my $current = 0;

sub EVENT_SPAWN {
    return unless $npc;

    # ✅ Boss stats
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", int(20000 * 1.15));
    $npc->ModifyNPCStat("max_hp", int(75500000 * 1.15));
    $npc->ModifyNPCStat("hp_regen", int(1000 * 1.15));
    $npc->ModifyNPCStat("mana_regen", int(10000 * 1.15));
    $npc->ModifyNPCStat("min_hit", int(20000 * 1.15));
    $npc->ModifyNPCStat("max_hit", int(40000 * 1.15));
    $npc->ModifyNPCStat("atk", int(1400 * 1.15));
    $npc->ModifyNPCStat("accuracy", int(2000 * 1.15));
    $npc->ModifyNPCStat("avoidance", int(90 * 1.15));
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 90);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 33);
    $npc->ModifyNPCStat("aggro", 400);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", int(1200 * 1.15));
    $npc->ModifyNPCStat("sta", int(1200 * 1.15));
    $npc->ModifyNPCStat("agi", int(1200 * 1.15));
    $npc->ModifyNPCStat("dex", int(1200 * 1.15));
    $npc->ModifyNPCStat("wis", int(1200 * 1.15));
    $npc->ModifyNPCStat("int", int(1200 * 1.15));
    $npc->ModifyNPCStat("cha", int(1000 * 1.15));

    $npc->ModifyNPCStat("mr", int(300 * 1.15));
    $npc->ModifyNPCStat("fr", int(300 * 1.15));
    $npc->ModifyNPCStat("cr", int(300 * 1.15));
    $npc->ModifyNPCStat("pr", int(300 * 1.15));
    $npc->ModifyNPCStat("dr", int(300 * 1.15));
    $npc->ModifyNPCStat("corruption_resist", int(500 * 1.15));
    $npc->ModifyNPCStat("physical_resist", int(1000 * 1.15));

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

    quest::setnexthpevent(75);

    quest::shout("My flames will devour you ALL!");

    quest::settimer("tintcycle", 15);

    # ✅ INSANE MODE — Attack all NPCs
    foreach my $mob ($entity_list->GetNPCList()) {
        next unless $mob && $mob->GetID() != $npc->GetID();
        $npc->AddToHateList($mob, 1);
    }
}

sub EVENT_HP {
    return unless $npc;
    if ($hpevent == 75) {
        quest::shout("My flames were once bound to Kunark’s plains... but here, in the Twilight, I BURN anew!");
        $npc->ModifyNPCStat("min_hit", int(25000 * 1.15));
        $npc->ModifyNPCStat("max_hit", int(45000 * 1.15));
        $npc->ModifyNPCStat("atk", int(1600 * 1.15));
        $npc->ModifyNPCStat("accuracy", int(2200 * 1.15));
        $npc->ModifyNPCStat("avoidance", int(95 * 1.15));
        quest::setnexthpevent(50);
    } elsif ($hpevent == 50) {
        quest::shout("The flames twist, the experiment holds — you cannot douse My fury!");
        $npc->ModifyNPCStat("min_hit", int(30000 * 1.15));
        $npc->ModifyNPCStat("max_hit", int(50000 * 1.15));
        $npc->ModifyNPCStat("atk", int(1800 * 1.15));
        $npc->ModifyNPCStat("accuracy", int(2400 * 1.15));
        $npc->ModifyNPCStat("avoidance", int(100 * 1.15));
        quest::setnexthpevent(25);
    } elsif ($hpevent == 25) {
        quest::shout("Varnol’s tethers snap — I will ignite all!");
        $npc->ModifyNPCStat("min_hit", int(35000 * 1.15));
        $npc->ModifyNPCStat("max_hit", int(60000 * 1.15));
        $npc->ModifyNPCStat("atk", int(2000 * 1.15));
        $npc->ModifyNPCStat("accuracy", int(2800 * 1.15));
        $npc->ModifyNPCStat("avoidance", int(110 * 1.15));
    }
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        for my $i (1..2) {
            quest::settimer("call_for_help_$i", int(rand(99)) + 1);
            quest::settimer("cleanse_debuff_$i", int(rand(99)) + 1);
        }
        quest::settimer("life_drain", 5);
        quest::settimer("ixi_fire_rain", 40);
    } else {
        for my $i (1..2) {
            quest::stoptimer("call_for_help_$i");
            quest::stoptimer("cleanse_debuff_$i");
        }
        quest::stoptimer("life_drain");
        quest::stoptimer("ixi_fire_rain");
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

        quest::shout("Infernal fragments, gather! Aid their destruction!");
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
        quest::shout("My flames consume your feeble hexes!");
    } elsif ($timer eq "ixi_fire_rain") {
        return unless $npc->IsEngaged();
        my $target = $npc->GetHateTop();
        if ($target && ($target->IsClient() || $target->IsBot())) {
            quest::shout("Feel the lames rain down upon you!");
            $npc->CastSpell(40759, $target->GetID());
        }
    } elsif ($timer eq "tintcycle") {
        $npc->SetNPCTintIndex($tints[$current]);
        my $shout = $tint_names{$tints[$current]} || "Shifting!";
        quest::shout($shout);
        $current = ($current + 1) % scalar(@tints);
    }
}

sub EVENT_ATTACK {
    return unless $npc;

    my $target = $npc->GetHateTop();
    return unless $target;

    if ($target->IsNPC() && !$target->IsPet() && !$target->IsClient() && !$target->IsBot()) {
        # Pure NPC: unleash one-shot damage style
        $npc->ModifyNPCStat("min_hit", 1000000);
        $npc->ModifyNPCStat("max_hit", 2000000);
    } else {
        # Players/bots/pets: restore normal stat damage
        $npc->ModifyNPCStat("min_hit", int(20000 * 1.15));
        $npc->ModifyNPCStat("max_hit", int(40000 * 1.15));
    }
}

sub EVENT_DAMAGE_TAKEN {
    return unless $npc;

    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;
        if (quest::ChooseRandom(1..100) <= 20) {
            $npc->Shout("The Wrath of Luclin is unleashed!");
            my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
            my $radius = 50;
            my $dmg = 40000;

            foreach my $e ($entity_list->GetClientList()) {
                $e->Damage($npc, $dmg, 0, 1, false) if $e->CalculateDistance($x, $y, $z) <= $radius;
            }
            foreach my $b ($entity_list->GetBotList()) {
                $b->Damage($npc, $dmg, 0, 1, false) if $b->CalculateDistance($x, $y, $z) <= $radius;
            }
        }
    }
    return $damage;
}

sub EVENT_DEATH {
    return unless $npc;

    my $last_tint_index = ($current == 0) ? scalar(@tints) - 1 : $current - 1;
    my $active_tint = $tints[$last_tint_index];
    my $item_id = $tint_to_item{$active_tint};

    if ($item_id) {
        $npc->AddItem($item_id, 1);
        quest::shout("You have shattered my form aligned with tint $active_tint — take the element’s power!");
    }
}

sub EVENT_DEATH_COMPLETE {
    return unless $npc;
    my $chance = quest::ChooseRandom(1..100);
    if ($chance <= 10) {
        my ($x, $y, $z, $h) = ($npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        quest::spawn2(1984, 0, 0, $x, $y, $z, $h);
    }
}