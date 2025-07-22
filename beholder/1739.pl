my $minions_spawned = 0;

sub EVENT_SPAWN {
    quest::settimer("check_buffs", 1);
    quest::settimer("check_engagement", 600); # 10-minute depop timer
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::stoptimer("check_engagement"); # Stop depop while in combat
        quest::settimer("spell_cast", 30);
        quest::settimer("minion_check", 1);
        quest::settimer("check_hp", 1);
        quest::settimer("elphaba_drain", 30);

        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Elphaba raises her hands, and a wicked green glow radiates as the air grows heavy with dark magic!");
        }
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "Elphaba raises her hands, and a wicked green glow radiates as the air grows heavy with dark magic!");
        }

        $npc->Attack($npc->GetHateTop());
    } elsif ($combat_state == 0) {
        quest::stoptimer("spell_cast");
        quest::stoptimer("minion_check");
        quest::stoptimer("check_hp");
        quest::stoptimer("elphaba_drain");
        quest::settimer("check_engagement", 600); # Restart depop timer
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_engagement") {
        if ($npc->GetHateList()->IsEmpty()) {
            quest::depop();
        }
    }

    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        $npc->CastSpell(12879, $npc->GetID()) if !$npc->FindBuff(12879);
    }

    if ($timer eq "spell_cast") {
        $npc->CastSpell(40604, $npc->GetID());
        $npc->Attack($npc->GetHateTop());
    }

    if ($timer eq "minion_check") {
        my $hp_ratio = $npc->GetHPRatio();
        if ($hp_ratio <= 75 && $minions_spawned < 1) {
            Summon_Minions(3);
            $minions_spawned = 1;
        } elsif ($hp_ratio <= 50 && $minions_spawned < 2) {
            Summon_Minions(3);
            $minions_spawned = 2;
        } elsif ($hp_ratio <= 25 && $minions_spawned < 3) {
            Summon_Minions(3);
            $minions_spawned = 3;
        }
    }

    if ($timer eq "check_hp") {
        if ($npc->GetHPRatio() <= 50) {
            $npc->SetSpecialAbility(46, 1); # Ranged immunity
            quest::stoptimer("check_hp");
        }
    }

    if ($timer eq "elphaba_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;
        my $drain_amount = plugin::RandomRange(5000, 20000);

        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Elphaba cackles as an emerald surge erupts, siphoning the very essence of those nearby!");
            if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $entity->Damage($npc, $drain_amount, 0, 1, false);
            }
            my $pet = $entity->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, $drain_amount, 0, 1, false);
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "Elphaba cackles as an emerald surge erupts, siphoning the very essence of those nearby!");
            if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $bot->Damage($npc, $drain_amount, 0, 1, false);
            }
            my $pet = $bot->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, $drain_amount, 0, 1, false);
            }
        }
    }
}

sub Summon_Minions {
    my ($count) = @_;
    for (my $i = 0; $i < $count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(1661, 0, 0, $x, $y, $z, $npc->GetHeading());
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("spell_cast");
    quest::stoptimer("minion_check");
    quest::stoptimer("check_hp");
    quest::stoptimer("elphaba_drain");
    quest::stoptimer("check_engagement");
    quest::signalwith(10, 3, 0);
}