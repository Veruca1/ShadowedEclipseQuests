sub EVENT_SPAWN {
    # Cast beneficial spells at spawn to keep itself buffed
    $npc->CastSpell(36895, $npc->GetID());   # Spirit of the Forest Howler
    $npc->CastSpell(171, $npc->GetID());     # Celerity
    $npc->CastSpell(278, $npc->GetID());     # SoW

    # Set the first HP event at 75%
    quest::setnexthpevent(75);
}

sub EVENT_AGGRO {
    # Cast AoE Fear immediately on aggro and start its 2-minute timer
    $npc->CastSpell(36896, 0);               # AoE Fear
    quest::settimer("fear", 120);             # AoE Fear every 120 seconds (2 minutes)

    # Start AoE Poison after 1 minute, then every 2 minutes
    quest::settimer("poison_start", 60);      # First AoE Poison after 60 seconds
}

sub EVENT_HP {
    if ($hpevent == 75) {
        # 75% HP event: Spawn NPC 1411 and 1412
        quest::spawn2(1411, 0, 0, $npc->GetX() + 10, $npc->GetY() + 10, $npc->GetZ(), $npc->GetHeading());
        quest::spawn2(1412, 0, 0, $npc->GetX() - 10, $npc->GetY() - 10, $npc->GetZ(), $npc->GetHeading());

        # Set the next HP event at 25%
        quest::setnexthpevent(25);
    }
    elsif ($hpevent == 25) {
        # 25% HP event: Spawn NPC 1411 and 1412 again
        quest::spawn2(1411, 0, 0, $npc->GetX() + 10, $npc->GetY() + 10, $npc->GetZ(), $npc->GetHeading());
        quest::spawn2(1412, 0, 0, $npc->GetX() - 10, $npc->GetY() - 10, $npc->GetZ(), $npc->GetHeading());
    }
}

sub EVENT_TIMER {
    if ($timer eq "fear") {
        # Cast Forest Dragon Fear (36896) on all players in range
        $npc->CastSpell(36896, 0);            # AoE Fear
    }
    elsif ($timer eq "poison_start") {
        # Cast first AoE Poison after 60 seconds, then start 2-minute interval
        $npc->CastSpell(844, 0);              # AoE Poison
        quest::settimer("poison", 120);       # Subsequent poisons every 120 seconds
        quest::stoptimer("poison_start");     # Stop the initial 1-minute timer
    }
    elsif ($timer eq "poison") {
        # Cast Ceticious Forest Cloud (844) on all players in range
        $npc->CastSpell(844, 0);              # AoE Poison
    }
}

sub EVENT_COMBAT {
    if (!$combat_state) {
        # Stop all timers if Severilous leaves combat (reset)
        quest::stoptimer("fear");
        quest::stoptimer("poison");
        quest::stoptimer("poison_start");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop all timers on death
    quest::stoptimer("fear");
    quest::stoptimer("poison");
    quest::stoptimer("poison_start");
}
