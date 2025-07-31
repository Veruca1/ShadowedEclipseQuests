use List::Util qw(max);

my $is_boss = 1;
my $wrath_triggered = 0;
my @spawn_npcids = (2169, 2170, 2171, 2172);
my @spawned_adds;

sub EVENT_SPAWN {
    quest::shout("The Umbral Chorus begins its dark refrain... and you are the audience to our dirge!");
    return unless $npc;

    # Boss stats
    $npc->ModifyNPCStat("level", 63);
    $npc->ModifyNPCStat("ac", 30000);
    $npc->ModifyNPCStat("max_hp", 75500000);
    $npc->ModifyNPCStat("hp_regen", 1000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 12000);
    $npc->ModifyNPCStat("max_hit", 20000);
    $npc->ModifyNPCStat("atk", 1400);
    $npc->ModifyNPCStat("accuracy", 2000);
    $npc->ModifyNPCStat("avoidance", 110);
    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 90);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 32);
    $npc->ModifyNPCStat("aggro", 60);
    $npc->ModifyNPCStat("assist", 1);
    $npc->ModifyNPCStat("str", 1200);
    $npc->ModifyNPCStat("sta", 1200);
    $npc->ModifyNPCStat("agi", 1200);
    $npc->ModifyNPCStat("dex", 1200);
    $npc->ModifyNPCStat("wis", 1200);
    $npc->ModifyNPCStat("int", 1200);
    $npc->ModifyNPCStat("cha", 1000);
    $npc->ModifyNPCStat("mr", 400);
    $npc->ModifyNPCStat("fr", 400);
    $npc->ModifyNPCStat("cr", 400);
    $npc->ModifyNPCStat("pr", 400);
    $npc->ModifyNPCStat("dr", 400);
    $npc->ModifyNPCStat("corruption_resist", 500);
    $npc->ModifyNPCStat("physical_resist", 1000);
    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # ✅ Plugin-based loot setup
my $veru = plugin::verugems();
my @veru_ids = keys %$veru;
$npc->AddItem($veru_ids[int(rand(@veru_ids))]);

my $grim = plugin::botgrim();
my @grim_ids = keys %$grim;
$npc->AddItem($grim_ids[int(rand(@grim_ids))]);

if (int(rand(100)) < 20) {
    my $gear = plugin::ch6classgear();
    my @all_gear_ids = map { @{$gear->{$_}} } keys %$gear;
    $npc->AddItem($all_gear_ids[int(rand(@all_gear_ids))]);
}

# 25% chance to add item ID 45480
if (int(rand(100)) < 15) {
    $npc->AddItem(45480);
}

# 25% chance to add item ID 43836
if (int(rand(100)) < 15) {
    $npc->AddItem(43836);
}

    quest::setnexthpevent(75);
}

sub EVENT_HP {
    return unless $npc;
    if ($hpevent == 75) {
        quest::shout("You feel my anger rise — your blows only sharpen my blade!");
        $npc->ModifyNPCStat("min_hit", 14000);
        $npc->ModifyNPCStat("max_hit", 22000);
        quest::setnexthpevent(50);
    } elsif ($hpevent == 50) {
        quest::shout("My wrath deepens! You will break before I do!");
        $npc->ModifyNPCStat("min_hit", 17000);
        $npc->ModifyNPCStat("max_hit", 26000);
        quest::setnexthpevent(25);
    } elsif ($hpevent == 25) {
        quest::shout("This is my final stand — every strike lands true!");
        $npc->ModifyNPCStat("min_hit", 20000);
        $npc->ModifyNPCStat("max_hit", 30000);
    }
}

sub EVENT_COMBAT {
    return unless $npc;
    if ($combat_state == 1) {
        for my $i (1..2) {
            quest::settimer("cleanse_debuff_$i", int(rand(99)) + 1);
        }
        quest::settimer("life_drain", 5);
        quest::settimer("add_wave", 10);
    } else {
        quest::stoptimer("life_drain");
        for my $i (1..2) {
            quest::stoptimer("cleanse_debuff_$i");
        }
        quest::stoptimer("add_wave");
        depop_adds();
    }
}

sub EVENT_TIMER {
    return unless $npc;
    if ($timer eq "life_drain") {
        my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
        foreach my $e ($entity_list->GetClientList(), $entity_list->GetBotList()) {
            $e->Damage($npc, 6000, 0, 1, false) if $e && $e->CalculateDistance($x, $y, $z) <= 50;
        }
    }
    if ($timer =~ /^cleanse_debuff_/) {
        quest::stoptimer($timer);
        return unless $npc->IsEngaged();
        $npc->BuffFadeAll();
        quest::shout("I shake off all magic!");
    }
    if ($timer eq "add_wave") {
        if ($npc->IsEngaged()) {
            if (@spawned_adds) {
                depop_adds();
            } else {
                spawn_adds();
            }
        } else {
            quest::stoptimer("add_wave");
            depop_adds();
        }
    }
}

sub EVENT_DAMAGE_TAKEN {
    return unless $npc;

    # Use plugin-based exclusion list for pets
    my $excluded_pet_npc_ids = plugin::GetExclusionList();

    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;

        if (quest::ChooseRandom(1..100) <= 20) {
            $npc->Shout("The Wrath of Luclin is unleashed!");
            my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());

            foreach my $e ($entity_list->GetClientList(), $entity_list->GetBotList()) {
                next unless $e && $e->CalculateDistance($x, $y, $z) <= 50;
                $e->Damage($npc, 40000, 0, 1, false);

                my $pet = $e->GetPet();
                if ($pet && $pet->CalculateDistance($x, $y, $z) <= 50) {
                    next if $excluded_pet_npc_ids->{$pet->GetNPCTypeID()};
                    $pet->Damage($npc, 40000, 0, 1, false);
                }
            }
        }
    }

    return $damage;
}

sub EVENT_DEATH_COMPLETE {
    return unless $npc;
    if (quest::ChooseRandom(1..100)<=10) {
        my ($x,$y,$z,$h)=($npc->GetX(),$npc->GetY(),$npc->GetZ(),$npc->GetHeading());
        quest::spawn2(1984,0,0,$x,$y,$z,$h);
    }
}

sub spawn_adds {
    my $count = 2 + int(rand(4));
    for (1..$count) {
        my $npc_id = $spawn_npcids[int(rand(@spawn_npcids))];
        my $mob_id = quest::spawn2($npc_id,0,0,$npc->GetX()+int(rand(20))-10,$npc->GetY()+int(rand(20))-10,$npc->GetZ(),$npc->GetHeading());
        push @spawned_adds, $mob_id;
    }
}

sub depop_adds {
    foreach my $id (@spawned_adds) {
        my $mob = $entity_list->GetMobByID($id);
        $mob->Depop() if $mob;
    }
    @spawned_adds = ();
}