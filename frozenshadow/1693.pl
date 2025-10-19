my $minions_spawned = 0;

sub EVENT_SPAWN {
    quest::settimer("check_buffs", 1);
}

sub EVENT_COMBAT {
    my ($combat_state) = @_;
    if ($combat_state == 1) {
        quest::settimer("spell_cast", 30);
        quest::settimer("minion_check", 1);
        quest::settimer("check_hp", 1);
        
        my $target = $npc->GetHateTop();
        $npc->Attack($target) if ($target);
    } elsif ($combat_state == 0) {
        quest::stoptimer("spell_cast");
        quest::stoptimer("minion_check");
        quest::stoptimer("check_hp");
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        $npc->CastSpell(12879, $npc->GetID()) if !$npc->FindBuff(12879);
    }

    if ($timer eq "spell_cast") {
        $npc->CastSpell(40604, $npc->GetID());
        
        my $target = $npc->GetHateTop();
        $npc->Attack($target) if ($target);
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
            $npc->SetSpecialAbility(47, 1); # Magic immunity
            quest::stoptimer("check_hp");
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
    
    my $x = $npc->GetX();
    my $y = $npc->GetY();
    my $z = $npc->GetZ();
    my $h = $npc->GetHeading();
    
    quest::spawn2(1694, 0, 0, $x, $y, $z, $h);
    quest::signalwith(10, 5);
}