sub EVENT_SPAWN {
    quest::settimer(1, 3600);                  # Depop timer
    quest::settimer("init_effects", 1);        # Buff/init visuals

    return unless $npc;

    # BOSS TIER STATS
    $npc->ModifyNPCStat("level", 64);
    $npc->ModifyNPCStat("ac", 20000);
    $npc->ModifyNPCStat("max_hp", 40500000);
    $npc->ModifyNPCStat("hp_regen", 1000);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 10000);
    $npc->ModifyNPCStat("max_hit", 15500);
    $npc->ModifyNPCStat("atk", 1400);
    $npc->ModifyNPCStat("accuracy", 2000);
    $npc->ModifyNPCStat("avoidance", 90);
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

    $npc->ModifyNPCStat("mr", 600);
    $npc->ModifyNPCStat("fr", 600);
    $npc->ModifyNPCStat("cr", 600);
    $npc->ModifyNPCStat("pr", 600);
    $npc->ModifyNPCStat("dr", 600);
    $npc->ModifyNPCStat("corruption_resist", 500);
    $npc->ModifyNPCStat("physical_resist", 1000);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "2,1^3,1^5,1^7,1^8,1^13,1^14,1^17,1^21,1^31,1");

    # Heal to full
    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;

    # Set HP event
    quest::setnexthpevent(75);
}

sub EVENT_TIMER {
    if ($timer eq "check_conditions") {
        return unless $npc;

        my $has_debuff = $npc->FindBuff(40752);
        my $top = $npc->GetHateTop();
        if ($top && $top->IsClient()) {
            my $client = $top->CastToClient();
            my $item = $client->GetItemIDAt(14);
            if ($has_debuff && $item == 42447) {
                $npc->SetSpecialAbility(35, 0); # Make vulnerable
            } else {
                $npc->SetSpecialAbility(35, 1); # Invulnerable
            }
        } else {
            $npc->SetSpecialAbility(35, 1);
        }
    }
    elsif ($timer eq "init_effects") {
        quest::stoptimer("init_effects");

        # Visuals
        $npc->SetNPCTintIndex(53);

        # Apply buff if not already present
        $npc->CastSpell(12403, $npc->GetID()) unless $npc->FindBuff(12403);
    }
    elsif ($timer == 1) {
        quest::depop();
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("check_conditions", 3);
    } else {
        quest::stoptimer("check_conditions");
        $npc->SetSpecialAbility(35, 1);
    }
}

sub EVENT_HP {
    return unless $npc;

    if ($hpevent == 75 || $hpevent == 25) {
        if ($npc->FindBuff(40745)) {
            plugin::Debug("Boss has debuff 40745 mark of silence, skipping help call.");
            return;
        }

        quest::shout("Surrounding minions of the Castle, arise and assist me!");
        my $top = $npc->GetHateTop();
        return unless $top;

        my @npcs = $entity_list->GetNPCList();
        return unless @npcs;

        foreach my $mob (@npcs) {
            next unless $mob && $mob->GetID() != $npc->GetID();
            my $dist = $npc->CalculateDistance($mob);
            $mob->AddToHateList($top, 1) if defined $dist && $dist <= 300;
        }

        quest::setnexthpevent(25) if $hpevent == 75;
    }
}