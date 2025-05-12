sub EVENT_SPAWN {
    # Start the timer for depop on spawn
    quest::settimer("depop_check", 300); # 300 seconds = 5 minutes
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Stop the depop timer if engaged in combat
        quest::stoptimer("depop_check");
    } elsif ($combat_state == 0) {
        # Restart the depop timer if combat ends
        quest::settimer("depop_check", 300);
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_check") {
        if (!$npc->IsEngaged()) {
            # Depop the NPC if not engaged
            quest::depop();
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Ensure the timer doesn't interfere post-death
    quest::stoptimer("depop_check");
}
