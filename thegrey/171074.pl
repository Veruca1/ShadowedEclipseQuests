use List::Util qw(max);

my $is_boss = 1;
my $wrath_triggered = 0;
my $pet_npc_id;
my %excluded_pet_npc_ids = ();

sub EVENT_SPAWN {
    return unless $npc;

    # Boss stats
    $npc->ModifyNPCStat("level", 63);
    $npc->ModifyNPCStat("ac", 30000);
    $npc->ModifyNPCStat("max_hp", 7550000);
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
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        my $target = $npc->GetHateTop();
        my $pet = $entity_list->GetNPCByID($pet_npc_id);
        $pet->AddToHateList($target, 1) if $pet && $target;

        for my $i (1..2) {
            quest::settimer("call_for_help_$i", int(rand(99)) + 1);
            quest::settimer("cleanse_debuff_$i", int(rand(99)) + 1);
        }

        quest::settimer("life_drain", 5);
    } else {
        quest::stoptimer("life_drain");
        for my $i (1..2) {
            quest::stoptimer("call_for_help_$i");
            quest::stoptimer("cleanse_debuff_$i");
        }
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

    if ($timer =~ /^call_for_help_/) {
        quest::stoptimer($timer);
        return unless $npc->IsEngaged();
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
    quest::shout("You will be food for the Knight! You best stear clear of these ruins!");
    #plugin::Debug("EVENT_DEATH_COMPLETE triggered.");

    my $ent = $entity_list->GetMobID($killer_id);
    my $pc;

    if ($ent) {
        if ($ent->IsClient()) {
            $pc = $ent->CastToClient();
            #plugin::Debug("Killer is client: " . $pc->GetCleanName());
        } elsif ($ent->IsPet()) {
            my $owner = $ent->GetOwner();
            if ($owner && $owner->IsClient()) {
                $pc = $owner->CastToClient();
                #plugin::Debug("Killer was pet, owner is client: " . $pc->GetCleanName());
            } elsif ($owner && $owner->IsBot()) {
                my $bot_owner = $owner->CastToBot()->GetOwner();
                if ($bot_owner && $bot_owner->IsClient()) {
                    $pc = $bot_owner->CastToClient();
                    #plugin::Debug("Killer was bot pet, owner is client: " . $pc->GetCleanName());
                }
            }
        } elsif ($ent->IsBot()) {
            my $owner = $ent->CastToBot()->GetOwner();
            if ($owner && $owner->IsClient()) {
                $pc = $owner->CastToClient();
                #plugin::Debug("Killer is bot, owner is client: " . $pc->GetCleanName());
            }
        }
    }

    unless ($pc) {
        #plugin::Debug("No valid client resolved from killer_id.");
        return;
    }

    my $cid = $pc->CharacterID();
    my $pname = $pc->GetCleanName();
    my $final_flag = "Grey_AllFlags_${cid}";
    my $has_flag = quest::get_data($final_flag);
    #plugin::Debug("Final flag [$final_flag] value: $has_flag");

    if ($has_flag) {
        if (quest::ChooseRandom(1..100) <= 30) {
            #plugin::Debug("Spawning 2177 at preset death location for $pname.");
            quest::spawn2(2177, 0, 0, 1545.21, -327.03, -12.02, 323.25);
        } else {
            #plugin::Debug("Spawn roll failed for $pname.");
        }
    } else {
        #plugin::Debug("Player $pname does not have the final flag.");
    }
}