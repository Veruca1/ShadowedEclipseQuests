use List::Util qw(max);

my $totem_timer_active = 0;
my $skeleton_timer_active = 0;
my $no_challengers_message_sent = 0;

my $is_boss = 1;
my $wrath_triggered = 0;
my $pet_npc_id;
my %excluded_pet_npc_ids = ();

sub EVENT_SPAWN {
    return unless $npc;

    quest::gmsay("The Malignant Umbral Revenant has awakened! Prepare yourselves, mortals.", 14, 1, 0, 0);

    # Boss Stats
    $npc->ModifyNPCStat("level", 65);
    $npc->ModifyNPCStat("ac", 30000);
    $npc->ModifyNPCStat("max_hp", 130500000);
    $npc->ModifyNPCStat("hp_regen", 1000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 45000);
    $npc->ModifyNPCStat("max_hit", 75000);
    $npc->ModifyNPCStat("atk", 2500);
    $npc->ModifyNPCStat("accuracy", 2000);
    $npc->ModifyNPCStat("avoidance", 50);
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
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1^33,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # ✅ Guaranteed loot
my $veru = plugin::verugems();
my @veru_ids = keys %$veru;
$npc->AddItem($veru_ids[int(rand(@veru_ids))]);

my $grey = plugin::botthegrey();
my @grey_ids = keys %$grey;
$npc->AddItem($grey_ids[int(rand(@grey_ids))]);

my $gear = plugin::ch6classgear();
my @gear_ids = map { @{$gear->{$_}} } keys %$gear;
$npc->AddItem($gear_ids[int(rand(@gear_ids))]);

# 🎲 50% chance at one of 45479, 45480, 45481, 45482, 45483, 45484
if (int(rand(100)) < 50) {
    my @bonus_ids = (45479, 45480, 45481, 45482, 45483, 45484);
    $npc->AddItem($bonus_ids[int(rand(@bonus_ids))]);
}

# 🏹 Guaranteed drop of 5 huntercred items (33208)
my $cred = plugin::huntercred();
my @cred_ids = keys %$cred;
for (1..5) {
    $npc->AddItem($cred_ids[0]);
}

# 25% chance to add item ID 45478
if (int(rand(100)) < 25) {
    $npc->AddItem(45478);
}

quest::settimer("phase_check", 1);
quest::settimer("check_combat", 2);
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        quest::shout("You dare challenge me?");
        my $target = $npc->GetHateTop();
        my $pet = $entity_list->GetNPCByID($pet_npc_id);
        $pet->AddToHateList($target, 1) if $pet && $target;

        if (!$totem_timer_active) {
            quest::settimer("totem_summon", 30);
            $totem_timer_active = 1;
        }
        if (!$skeleton_timer_active) {
            quest::settimer("skeleton_summon", 37);
            $skeleton_timer_active = 1;
        }

        for my $i (1..2) {
            quest::settimer("call_for_help_$i", int(rand(99)) + 1);
            quest::settimer("cleanse_debuff_$i", int(rand(99)) + 1);
        }

        quest::settimer("life_drain", 5);
        $no_challengers_message_sent = 0;

    } elsif ($combat_state == 0) {
        quest::shout("You cannot hide from me forever.");
        quest::stoptimer("totem_summon");
        quest::stoptimer("skeleton_summon");
        quest::stoptimer("life_drain");

        for my $i (1..2) {
            quest::stoptimer("call_for_help_$i");
            quest::stoptimer("cleanse_debuff_$i");
        }

        $totem_timer_active = 0;
        $skeleton_timer_active = 0;
    }
}

sub EVENT_TIMER {
    return unless $npc;

    if ($timer eq "phase_check") {
        if ($npc->GetHPRatio() > 75) {
            Phase1_Mechanics();
        } elsif ($npc->GetHPRatio() <= 75 && $npc->GetHPRatio() > 40) {
            Phase2_Mechanics();
        } elsif ($npc->GetHPRatio() <= 40) {
            Phase3_Mechanics();
        }
    }

    if ($timer eq "totem_summon") {
        Summon_Totems();
    }

    if ($timer eq "skeleton_summon") {
        Summon_Skeletons();
    }

    if ($timer eq "check_combat") {
        if (!$npc->IsEngaged()) {
            quest::stoptimer("totem_summon");
            quest::stoptimer("skeleton_summon");
            $totem_timer_active = 0;
            $skeleton_timer_active = 0;

            if (!$no_challengers_message_sent) {
                quest::shout("The Revenant grows still as it senses no challengers.");
                $no_challengers_message_sent = 1;
            }
        } else {
            if (!$totem_timer_active) {
                quest::settimer("totem_summon", 30);
                $totem_timer_active = 1;
            }
            if (!$skeleton_timer_active) {
                quest::settimer("skeleton_summon", 37);
                $skeleton_timer_active = 1;
            }
            $no_challengers_message_sent = 0;
        }
    }

    if ($timer eq "life_drain") {
        my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
        foreach my $e ($entity_list->GetClientList(), $entity_list->GetBotList()) {
            $e->Damage($npc, 6000, 0, 1, false) if $e && $e->CalculateDistance($x, $y, $z) <= 50;
        }
    }

    if ($timer =~ /^call_for_help_/) {
    quest::stoptimer($timer);
    return unless $npc->IsEngaged();

    # Silence if debuffed with Mark of Silence
    if ($npc->FindBuff(40745)) {
        return;
    }

    quest::shout("Children of the Grey, attack the intruders!");
    my $top = $npc->GetHateTop();
    return unless $top;

    foreach my $mob ($entity_list->GetNPCList()) {
        next if $mob->GetID() == $npc->GetID();
        $mob->AddToHateList($top, 1) if $npc->CalculateDistance($mob) <= 500;
    }
}

    if ($timer =~ /^cleanse_debuff_/) {
        quest::stoptimer($timer);
        return unless $npc->IsEngaged();
        $npc->BuffFadeAll();
        quest::shout("I shake off all magic!");
    }
}

sub EVENT_DAMAGE_TAKEN {
    return unless $npc;

    if (!$wrath_triggered && $npc->GetHP() <= ($npc->GetMaxHP() * 0.10)) {
        $wrath_triggered = 1;

        if (quest::ChooseRandom(1..100) <= 20) {
            $npc->Shout("The Wrath of Luclin is unleashed!");
            my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());

            foreach my $e ($entity_list->GetClientList(), $entity_list->GetBotList()) {
                next unless $e && $e->CalculateDistance($x, $y, $z) <= 50;
                $e->Damage($npc, 40000, 0, 1, false);
                my $pet = $e->GetPet();
                if ($pet && $pet->CalculateDistance($x, $y, $z) <= 50 && !$excluded_pet_npc_ids{$pet->GetNPCTypeID()}) {
                    $pet->Damage($npc, 40000, 0, 1, false);
                }
            }
        }
    }

    return $damage;
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Hahaha, enjoy your short lived victory, you have no idea what fresh hell awaits you in the Temple!");
    quest::stoptimer("phase_check");
    quest::stoptimer("totem_summon");
    quest::stoptimer("skeleton_summon");
    quest::stoptimer("check_combat");
    quest::stoptimer("life_drain");
    $totem_timer_active = 0;
    $skeleton_timer_active = 0;
    quest::depop();
}

sub Phase1_Mechanics {
    quest::castspell(40768, $npc->GetID());  # Bone Shield II
}

sub Phase2_Mechanics {
    quest::castspell(40769, $npc->GetID());  # Cursed Aura II
    quest::castspell(40770, $npc->GetID());  # Shadow Vortex II
}

sub Phase3_Mechanics {
    quest::castspell(40771, $npc->GetID());  # Blood Sacrifice
    quest::castspell(40772, $npc->GetID());  # Death's Grasp
}

sub Summon_Totems {
    my $totem_count = plugin::RandomRange(1, 3);
    for (my $i = 0; $i < $totem_count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(1255, 0, 0, $x, $y, $z, $npc->GetHeading());
    }
}

sub Summon_Skeletons {
    my $skeleton_count = plugin::RandomRange(1, 2);
    for (my $i = 0; $i < $skeleton_count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-15, 15);
        my $y = $npc->GetY() + plugin::RandomRange(-15, 15);
        my $z = $npc->GetZ();
        quest::spawn2(1254, 0, 0, $x, $y, $z, $npc->GetHeading());
    }
}
