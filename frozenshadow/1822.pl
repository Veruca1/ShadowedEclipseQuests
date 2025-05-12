sub EVENT_SPAWN {
    quest::settimer("depop_check", 300);  # 300 seconds = 5 minutes
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Engaged in combat
        quest::stoptimer("depop_check");
    } elsif ($combat_state == 0) {  # Out of combat
        quest::settimer("depop_check", 300);
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_check") {
        $npc->Depop();
    }
}