sub EVENT_SPAWN {
    # Set a timer to change the appearance to sitting after 3 seconds
    quest::settimer("sit_timer", 3);  # 3 seconds
}

sub EVENT_TIMER {
    if ($timer eq "sit_timer") {
        # Make NPC 1684 sit after 3 seconds
        $npc->SetAppearance(3);  # 3 = Sitting animation
        quest::stoptimer("sit_timer");  # Stop the timer after sitting
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # 1 means combat has started
        # Make NPC 1684 stand up when combat starts
        $npc->SetAppearance(0);  # 0 = Standing animation
    } elsif ($combat_state == 0) {  # 0 means combat has ended
        # Make NPC 1684 sit again after combat ends
        quest::settimer("sit_timer", 3);  # Reset timer to sit after 3 seconds
    }
}
