sub EVENT_SPAWN {
    quest::castspell(17851, $npc->GetID());
    quest::castspell(12932, $npc->GetID());		
    # Initialize NPC state
    $npc->SetInvul(1);  # Make NPC invulnerable
    $npc->SetDisableMelee(1);  # Disable melee attacks for invulnerable phase
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Combat started (no timer actions needed here anymore)
    }
    elsif ($combat_state == 0) {
        # Combat ended (no timer actions needed here anymore)
    }
}

sub EVENT_DEATH {
    # Send signal with value 6 to NPC ID 1581 when NPC dies
    quest::signal(1581, 6);
}
