my $totem_timer_active = 0; 

sub EVENT_SPAWN {
    quest::settimer("check_combat", 2);  # Check if the NPC is still in combat every 2 seconds
}

sub EVENT_TIMER {
    if ($timer eq "totem_summon") {
        Summon_Totems();
    }

    if ($timer eq "check_combat") {
        if (!$npc->IsEngaged()) {
            # Stop all timers when not engaged
            quest::stoptimer("totem_summon");
            $totem_timer_active = 0;
        } else {
            # Restart the totem summon timer if not already running
            if (!$totem_timer_active) {
                quest::settimer("totem_summon", 30);  # Restart totem summon timer
                $totem_timer_active = 1;
            }
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat starts
        if (!$totem_timer_active) {
            quest::settimer("totem_summon", 30);
            $totem_timer_active = 1;
        }
    } elsif ($combat_state == 0) {  # Combat ends
        quest::stoptimer("totem_summon");
        $totem_timer_active = 0;
    }
}

sub Summon_Totems {
    my $totem_count = plugin::RandomRange(1, 3);  # Summons 1-3 totems randomly

    for (my $i = 0; $i < $totem_count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);  # Randomize spawn location slightly
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(1403, 0, 0, $x, $y, $z, $npc->GetHeading());  # Spawn the totem NPC
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("totem_summon");
    quest::stoptimer("check_combat");
    $totem_timer_active = 0;
    quest::depop();  # Ensures the NPC is fully removed from the game.
}
