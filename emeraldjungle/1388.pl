sub EVENT_SPAWN {
    # No timers are started here since all actions should happen during combat
}

sub EVENT_AGGRO {
    # Start the Time Blur and Time Dilation spell timers upon aggro
    quest::settimer("cast_time_blur", 30);
    quest::settimer("cast_time_dilation", 80);
    
    # Start the invulnerability shift timer during combat only
    quest::settimer("shift_time", 90);
}

sub EVENT_COMBAT {
    # Stop all timers if the NPC is no longer in combat
    if (!$combat_state) {
        quest::stoptimer("cast_time_blur");
        quest::stoptimer("cast_time_dilation");
        quest::stoptimer("shift_time");
        quest::stoptimer("remove_invul");
    }
}

sub EVENT_TIMER {
    if ($timer eq "shift_time") {
        # Make the NPC invulnerable
        $npc->SetInvul(true);
        
        # Emote to players that the NPC has shifted out of time
        quest::emote("shifts out of time, becoming invulnerable.");
        
        # Set a temporary timer to remove invulnerability after 5 seconds
        quest::settimer("remove_invul", 5);
    }

    if ($timer eq "remove_invul") {
        # Remove invulnerability after 5 seconds
        $npc->SetInvul(false);
        
        # Optional emote to notify players that the NPC has returned to normal
        quest::emote("shifts back into the flow of time.");
        
        # Stop the temporary timer
        quest::stoptimer("remove_invul");
    }

    if ($timer eq "cast_time_blur") {
        # Only cast if the NPC has a valid hate target
        my $target = $npc->GetHateTop();
        if ($target) {
            # Cast Time Blur spell (spell ID 36876) on the top hate target
            $npc->CastSpell(36876, $target->GetID());
        }
    }

    if ($timer eq "cast_time_dilation") {
        # Only cast if the NPC has a valid hate target
        my $target = $npc->GetHateTop();
        if ($target) {
            # Cast Time Dilation spell (spell ID 36877) on the top hate target
            $npc->CastSpell(36877, $target->GetID());
        }
    }
}

sub EVENT_DEATH {
    # Stop all timers when the NPC dies
    quest::stoptimer("shift_time");
    quest::stoptimer("remove_invul");
    quest::stoptimer("cast_time_blur");
    quest::stoptimer("cast_time_dilation");
}
