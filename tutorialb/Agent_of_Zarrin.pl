# NPC: Agent_of_Zarrin
# Veruca

sub EVENT_SPAWN {
    # Prevent duplicate spawn of Agent_of_Zarrin
    my $npc_id = 12345;  # Replace with the actual NPC ID for Agent_of_Zarrin
    my $npc_spawned = quest::isnpcspawned($npc_id);
    
    if (!$npc_spawned) {
        # Apply buff 20145 to the NPC when it spawns
        $npc->SpellFinished(20145, $npc);
        
        # Spawn shout message
        quest::shout("Who has summoned me to this wretched place!");

    }
}

sub EVENT_COMBAT {
    quest::emote("looks upon you with disbelief, you feel as if you may have made a mistake angering this one.");
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("Darkness looms, shadows stir. Zarrin's will commands the unseen. Beware the whispers in the tomb of the Fallen.");
}

# EOF zone: Tutorialb
