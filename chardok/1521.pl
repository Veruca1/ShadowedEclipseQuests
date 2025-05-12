sub EVENT_SPAWN {
    # Start a 2-minute timer called "check_combat"
    quest::settimer("check_combat", 120);
}

sub EVENT_TIMER {
    if ($timer eq "check_combat") {
        # Check if the NPC is not in combat
        if (!$npc->IsEngaged()) {
            quest::depop(); # Depop the NPC
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC entered combat, stop the timer
        quest::stoptimer("check_combat");
    } elsif ($combat_state == 0) {
        # NPC exited combat, restart the 2-minute timer
        quest::settimer("check_combat", 120);
    }
}
