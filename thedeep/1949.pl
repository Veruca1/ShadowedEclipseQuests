sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::signalwith(1947, 999); # Signal THO to stop countdown
    }
}