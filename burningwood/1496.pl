my $minions_spawned = 0;

sub EVENT_SPAWN {
    quest::settimer("check_buffs", 1);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  
        quest::shout("Well well well! Look who it is! Thought this was over? We're just getting warmed up!");
        quest::settimer("spell_cast", 30);
        quest::settimer("minion_check", 1);
        $npc->Attack($npc->GetHateTop());  # Re-engage attack on top hated target
    } elsif ($combat_state == 0) {  
        quest::stoptimer("spell_cast");
        quest::stoptimer("minion_check");
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        # Apply initial buffs only once to avoid disruptions in combat
        quest::stoptimer("check_buffs");  # Stop rechecking this timer continuously
        $npc->CastSpell(13378, $npc->GetID()) if !$npc->FindBuff(13378);
        $npc->CastSpell(12933, $npc->GetID()) if !$npc->FindBuff(12933);
    }

    if ($timer eq "spell_cast") {
        $npc->CastSpell(36942, $npc->GetID());
        $npc->Attack($npc->GetHateTop());  # Re-engage attack after casting
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
}

sub Summon_Minions {
    my ($count) = @_;
    quest::shout("Minions, assist me in battle!");
    for (my $i = 0; $i < $count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(1512, 0, 0, $x, $y, $z, $npc->GetHeading());
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("You know as well as I, This isn't over and you can't hide behind a veil for too long! Hahahaha!");
    quest::stoptimer("spell_cast");
    quest::stoptimer("minion_check");
}
