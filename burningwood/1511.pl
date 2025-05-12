sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC is engaged in combat
        quest::settimer("cast_spell", 35);  # Set a timer to cast every 35 seconds
    } else {
        # NPC is out of combat
        quest::stoptimer("cast_spell");  # Stop the timer when combat ends
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_spell") {
        my $target = $npc->GetHateTop();  # Get the top hate target (usually the player)
        if ($target) {  # Check if a target exists
            $npc->CastSpell(36941, $target->GetID());  # Cast spell 36941 on the top hate target
        }
    }
}
