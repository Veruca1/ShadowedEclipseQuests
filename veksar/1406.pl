sub EVENT_SPAWN {
    quest::settimer("check_combat", 30);  # Timer to check if NPC is in combat every 30 seconds
}

sub EVENT_TIMER {
    if ($timer eq "check_combat") {
        if (!$npc->IsEngaged()) {  # If not in combat
            quest::depop();  # Depop the NPC
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # NPC enters combat
        quest::stoptimer("check_combat");  # Stop the depop timer when NPC is engaged in combat
    } elsif ($combat_state == 0) {  # NPC leaves combat
        quest::settimer("check_combat", 30);  # Restart the depop timer when NPC leaves combat
    }
}
