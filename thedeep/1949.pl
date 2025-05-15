sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::signalwith(1947, 999); # Signal THO to stop countdown
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1947, 45); # Signal THO to remove invulnerability and resume fight
}