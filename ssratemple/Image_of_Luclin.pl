my $wrath_active = 0;
my $checked_mirror = 0;
my $mirror_trigger_hp = 0;

sub EVENT_SPAWN {
    return unless $npc;

    $wrath_active = 0;
    $checked_mirror = 0;

    quest::settimer("init_effects", 1);
    quest::settimer("lunar_nimbus_buff", 8);

    my $raw_name = $npc->GetName() || '';
    my $npc_id   = $npc->GetNPCTypeID() || 0;
    return if $npc->IsPet();

    my $exclusion_list = plugin::GetExclusionList();
    return if exists $exclusion_list->{$npc_id};

    # Base stats
    $npc->SetNPCFactionID(623);
    $npc->ModifyNPCStat("level", 75);
    $npc->ModifyNPCStat("ac", 29000);
    $npc->ModifyNPCStat("max_hp", 130000000);
    $npc->ModifyNPCStat("hp_regen", 1500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 40000);
    $npc->ModifyNPCStat("max_hit", 80000);
    $npc->ModifyNPCStat("atk", 1700);
    $npc->ModifyNPCStat("accuracy", 1800);
    $npc->ModifyNPCStat("avoidance", 100);
    $npc->ModifyNPCStat("attack_delay", 6);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 80);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 19);
    $npc->ModifyNPCStat("aggro", 55);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1000);
    $npc->ModifyNPCStat("sta", 1000);
    $npc->ModifyNPCStat("agi", 1000);
    $npc->ModifyNPCStat("dex", 1000);
    $npc->ModifyNPCStat("wis", 1000);
    $npc->ModifyNPCStat("int", 1000);
    $npc->ModifyNPCStat("cha", 800);

    $npc->ModifyNPCStat("mr", 2000);
    $npc->ModifyNPCStat("fr", 2000);
    $npc->ModifyNPCStat("cr", 2000);
    $npc->ModifyNPCStat("pr", 2000);
    $npc->ModifyNPCStat("dr", 2000);
    $npc->ModifyNPCStat("corruption_resist", 300);
    $npc->ModifyNPCStat("physical_resist", 800);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);
    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^15,1^17,1^21,1^31,1");

    $npc->SetHP($npc->GetMaxHP());
}

sub EVENT_COMBAT {
    return unless $npc;

    if ($combat_state == 1) {
        quest::settimer("lunar_eclipse", 60);
        quest::settimer("wrath_of_luclin", 30);
        quest::settimer("mirror_check", 5);
    } else {
        quest::stoptimer("lunar_eclipse");
        quest::stoptimer("wrath_of_luclin");
        quest::stoptimer("mirror_check");
        $checked_mirror = 0;
    }
}

sub EVENT_TIMER {
    if ($timer eq "init_effects") {
        quest::stoptimer("init_effects");

        my @buffs = (5278, 5297, 5488, 10028, 10031, 10013, 10664, 9414, 300, 15031, 2530);
        foreach my $spell_id (@buffs) {
            $npc->SpellFinished($spell_id, $npc);
        }
        quest::shout("Through shadow and silence, I return... and the Moon sees all.");
    }
    elsif ($timer eq "lunar_nimbus_buff") {
        quest::stoptimer("lunar_nimbus_buff");
        $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);
    }
    elsif ($timer eq "lunar_eclipse") {
        if ($npc->IsEngaged()) {
            my $target = $npc->GetHateTop();
            $npc->CastSpell(40782, $target->GetID()) if $target;
        }
    }
    elsif ($timer eq "wrath_of_luclin") {
        if ($npc->IsEngaged()) {
            $npc->Shout("My Wrath is unleashed!");
            my ($x, $y, $z) = ($npc->GetX(), $npc->GetY(), $npc->GetZ());
            my $radius = 50;
            my $dmg = 30000;
            my $excluded = plugin::GetExclusionList();

            foreach my $c ($entity_list->GetClientList()) {
                next unless $c;
                $c->Damage($npc, $dmg, 0, 1, false) if $c->CalculateDistance($x, $y, $z) <= $radius;
                my $pet = $c->GetPet();
                if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                    next if $excluded->{$pet->GetNPCTypeID()};
                    $pet->Damage($npc, $dmg, 0, 1, false);
                }
            }

            foreach my $b ($entity_list->GetBotList()) {
                next unless $b;
                $b->Damage($npc, $dmg, 0, 1, false) if $b->CalculateDistance($x, $y, $z) <= $radius;
                my $pet = $b->GetPet();
                if ($pet && $pet->CalculateDistance($x, $y, $z) <= $radius) {
                    next if $excluded->{$pet->GetNPCTypeID()};
                    $pet->Damage($npc, $dmg, 0, 1, false);
                }
            }
        }
    }
    elsif ($timer eq "mirror_check") {
        return if $checked_mirror;

        my $hp_pct = int($npc->GetHPRatio());
        return if $hp_pct > 80 || $hp_pct < 10;

        foreach my $client ($entity_list->GetClientList()) {
            next unless $client;
            next if $client->GetHP() <= 0;

            my $item = $client->GetItemAt(22);
            my $item_id = $item ? $item->GetID() : 0;
            my $has_mirror = ($item_id == 49764);
            my $has_buff   = $client->FindBuff(40778);

            next unless $has_mirror && $has_buff;

            my $roll = int(rand(100));
            if ($roll < 20) {
                quest::shout("The mirror cracks... and something darker stirs.");
                $npc->ModifyNPCStat("max_hp", int($npc->GetMaxHP() * 1.5));
                $npc->ModifyNPCStat("min_hit", int($npc->GetMinDMG() * 1.5));
                $npc->ModifyNPCStat("max_hit", int($npc->GetMaxDMG() * 1.5));
                $npc->ModifyNPCStat("atk", int($npc->GetATK() * 1.5));
                $npc->ModifyNPCStat("attack_delay", 5);
                $npc->ModifyNPCStat("heroic_strikethrough", 20);
                $npc->SetHP($npc->GetMaxHP());
                $npc->CastSpell(21388, $npc->GetID()) if !$npc->FindBuff(21388);
                $npc->SetNPCTintIndex(30);
            }

            $checked_mirror = 1;
            quest::stoptimer("mirror_check");
            last;
        }
    }
}