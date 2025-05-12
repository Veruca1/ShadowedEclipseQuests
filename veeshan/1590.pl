my $combat_timer = 600;  # 10 minutes (in seconds)

sub EVENT_SPAWN {
    # Set the initial timers
    quest::settimer("CombatCheck", $combat_timer);
    quest::castspell(17851, $npc->GetID());
    quest::castspell(12932, $npc->GetID());		
    # Initialize NPC state
    #$npc->SetInvul(0);  # Make NPC invulnerable
    #$npc->SetDisableMelee(0);  # Disable melee attacks for invulnerable phase
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Combat started, stop the depop timer
        quest::stoptimer("CombatCheck");
    }
    elsif ($combat_state == 0) {
        # Combat ended, start the depop timer
        quest::settimer("CombatCheck", $combat_timer);
    }
}

sub EVENT_TIMER {
    if ($timer eq "CombatCheck") {
        # Depop NPC if no combat for 5 minutes
        quest::depop();
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop the combat timer when NPC dies
    quest::stoptimer("CombatCheck");
    # Spawn NPC 1591 at the specified location
        quest::spawn2(1591, 0, 0, -400.93, 195.57, 445.07, 510.47);
}
