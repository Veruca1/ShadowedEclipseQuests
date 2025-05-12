my %signals_received = ();  # Hash to track received signals

sub EVENT_SPAWN {
    quest::settimer(1,1);
}

sub EVENT_TIMER {
    if ($timer eq "1") {
        $npc->SetAppearance(1);
        quest::stoptimer(1);
    }
}

sub EVENT_SIGNAL {
    if ($signal == 66 || $signal == 67 || $signal == 68 || $signal == 69) {
        $signals_received{$signal} = 1;  # Mark signal as received

        # Check if all four signals (66, 67, 68, 69) have been received at least once
        if (scalar(keys %signals_received) == 4) {
            quest::shout("I AM FREE!");
            quest::depop_withtimer();
            quest::spawn2(128089,1,0,-1499,-2344.8,-1052.8,0); # NPC: #Kerafyrm
        }
    }
}
