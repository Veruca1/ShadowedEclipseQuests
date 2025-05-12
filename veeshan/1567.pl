sub EVENT_SPAWN {
    quest::setnexthpevent(70);       # Set the first health trigger
    # No timers or actions until combat begins
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {        # Engaged in combat
        quest::settimer("dragons_call", 120); # Start the timer for Dragon's Call
    } elsif ($combat_state == 0) {  # Out of combat
        quest::stoptimer("dragons_call");     # Stop the spell timer
        reset_health_triggers();             # Reset health-based events
    }
}

sub EVENT_HP {
    if ($npc->IsEngaged()) {        # Ensure minions only spawn during combat
        if ($hpevent == 70) {
            spawn_minions();        # Spawn minions at 70% health
            quest::setnexthpevent(10);  # Set the next health trigger
        } elsif ($hpevent == 10) {
            spawn_minions();        # Spawn minions at 10% health
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "dragons_call" && $npc->IsEngaged()) { # Ensure spell only during combat
        cast_dragons_call();
    }
}

sub spawn_minions {
    for (my $i = 0; $i < 10; $i++) {
        # Spawn 10 minions around the NPC with slight random offsets
        quest::spawn2(1568, 0, 0, $x + (rand(20) - 10), $y + (rand(20) - 10), $z, $h);
    }
}

sub cast_dragons_call {
    # Cast Dragon's Call (ID 36958) on all players within range
    $npc->CastSpell(36958, $npc->GetID());
    quest::shout("Feel the wrath of the Dragon's Call!"); # Optional dramatic announcement
}

sub reset_health_triggers {
    quest::setnexthpevent(70);  # Reset health triggers when combat ends
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1427, 27, 0);
}