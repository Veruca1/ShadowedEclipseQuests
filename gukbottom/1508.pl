sub EVENT_COMBAT {
    if ($combat_state == 1) {  # When the NPC enters combat
        # Start a timer to cast spell every 120 seconds
        quest::settimer("cast_spell_36939", 120);
    } 
    elsif ($combat_state == 0) {  # When the NPC exits combat
        # Stop the timer when combat ends
        quest::stoptimer("cast_spell_36939");
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_spell_36939") {
        # Get the target of the NPC
        my $target = $npc->GetTarget();
        
        # Check if the target is valid and is a player
        if ($target && $target->IsClient()) {
            # Cast spell 36939 on the target (the player)
            $npc->CastSpell(36939, $target->GetID());
        }
    }
}
