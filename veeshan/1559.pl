sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("hp_check", 2); # Start checking HP every 2 seconds when combat starts
    } else {
        quest::stoptimer("hp_check"); # Stop the HP check when combat ends
    }
}

sub EVENT_TIMER {
    if ($timer eq "hp_check") {
        my $current_hp = $npc->GetHPRatio();

        # Trigger Blood Fury at 90% HP
        if ($current_hp <= 90 && !$qglobals{berserker_phase_90}) {
            quest::setglobal("berserker_phase_90", 1, 7, "F");
            $npc->CastSpell(6381, $npc->GetID()); # Blood Fury
            quest::shout("Feel the fury of my rage!");
        }

        # Trigger Whirlwind Discipline at 60% HP
        if ($current_hp <= 60 && !$qglobals{berserker_phase_60}) {
            quest::setglobal("berserker_phase_60", 1, 7, "F");
            $npc->CastSpell(4509, $npc->GetID()); # Whirlwind Discipline
            quest::shout("You cannot escape my whirlwind of destruction!");
        }

        # Trigger Savage Spirit at 30% HP
        if ($current_hp <= 30 && !$qglobals{berserker_phase_30}) {
            quest::setglobal("berserker_phase_30", 1, 7, "F");
            $npc->CastSpell(6090, $npc->GetID()); # Savage Spirit
            quest::shout("Witness the true power of a berserker!");
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Cleanup global variables on death
    quest::delglobal("berserker_phase_90");
    quest::delglobal("berserker_phase_60");
    quest::delglobal("berserker_phase_30");
    quest::signalwith(1427, 20, 0);
}