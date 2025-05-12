sub EVENT_SPAWN {
    # Set a timer to check for engagement
    quest::settimer("check_engagement", 600); # 600 seconds = 10 minutes
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Entering combat
        # Stop the depop timer when combat starts
        quest::stoptimer("check_engagement");
    } elsif ($combat_state == 0) { # Leaving combat
        # Restart the depop timer when combat ends
        quest::settimer("check_engagement", 600); # 10 minutes
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_engagement") {
        # Check if the NPC is engaged
        if ($npc->GetHateTop() == undef) {
            # Depop if not engaged
            quest::depop();
        }
    }
}
