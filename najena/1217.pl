sub EVENT_SPAWN {
    # Set a timer to check if the NPC is idle every 60 seconds
    quest::settimer("check_combat", 60);
}

sub EVENT_TIMER {
    if ($timer eq "check_combat") {
        # If the NPC is not in combat, check if it's been idle for more than 5 minutes
        if (!$npc->IsEngaged()) {
            my $idle_time = quest::get_data("npc_idle_" . $npc->GetID());

            if (!defined($idle_time)) {
                # If this is the first time checking, store the current time
                quest::set_data("npc_idle_" . $npc->GetID(), time(), 300);  # Set to expire in 5 minutes
            } elsif (time() - $idle_time >= 300) {  # 5 minutes of inactivity
                quest::delete_data("npc_idle_" . $npc->GetID());  # Clear the idle time data
                quest::depop();  # Depop the NPC (remove it)
            }
        } else {
            # Reset the idle timer when the NPC engages in combat
            quest::delete_data("npc_idle_" . $npc->GetID());  # Reset idle data on combat
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has engaged in combat, reset the timer
        quest::delete_data("npc_idle_" . $npc->GetID());  # Clear idle time data
    } else {
        # NPC has left combat, so start the idle check again
        quest::set_data("npc_idle_" . $npc->GetID(), time(), 300);  # Start timer from current time
    }
}

sub EVENT_DEATH {
    # Stop any timers when the NPC dies
    quest::stoptimer("check_combat");
    quest::delete_data("npc_idle_" . $npc->GetID());  # Cleanup any data
}
