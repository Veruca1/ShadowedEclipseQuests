my $minions_spawned = 0;

sub EVENT_SPAWN {
    quest::settimer("check_buffs", 1);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("spell_cast", 30);
        quest::settimer("minion_check", 1);
        quest::settimer("check_hp", 1);  # Start checking health during combat
        $npc->Attack($npc->GetHateTop());  # Re-engage attack on top hated target
    } elsif ($combat_state == 0) {
        quest::stoptimer("spell_cast");
        quest::stoptimer("minion_check");
        quest::stoptimer("check_hp");  # Stop health checks when combat ends
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        $npc->CastSpell(12879, $npc->GetID()) if !$npc->FindBuff(12879);
    }

    if ($timer eq "spell_cast") {
        $npc->CastSpell(40604, $npc->GetID());
        $npc->Attack($npc->GetHateTop());  # Re-engage attack after casting
    }

    if ($timer eq "minion_check") {
        my $hp_ratio = $npc->GetHPRatio();

        # Summon 3 minions at each health threshold
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
        # Check if NPC's health is at or below 50%
        if ($npc->GetHPRatio() <= 50) {
            # Make the NPC immune to ranged and magic attacks
            $npc->SetSpecialAbility(46, 1); # Ranged immunity            
            # Stop further checks to prevent re-triggering
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
    quest::stoptimer("check_hp");  # Stop health checks on death
    quest::signalwith(10, 3, 0);
}
