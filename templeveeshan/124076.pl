sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Tell controller that combat has started
        quest::signalwith(1911, 999);
    }
}

sub EVENT_DEATH_COMPLETE {    
        quest::signalwith(1911, 992);
    }