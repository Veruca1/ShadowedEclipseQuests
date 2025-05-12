sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Start the timer for Temporal Rip (cast after 20 seconds)
        quest::settimer("cast_temporal_rip", 20);
        # Start the timer to spawn NPC 1376 every 25 seconds
        quest::settimer("spawn_minion", 25);
    } else {
        # Stop timers and depop minions if combat ends
        quest::stoptimer("cast_temporal_rip");
        quest::stoptimer("spawn_minion");
        quest::depopall(1376);  # Depop all minions (NPC 1376)
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_temporal_rip") {
        # Cast Temporal Rip (spell ID 36884)
        $npc->CastSpell(36884, $npc->GetTarget()->GetID());
        quest::stoptimer("cast_temporal_rip");  # Only cast once
    }
    
    if ($timer eq "spawn_minion") {
        # Spawn NPC 1376 every 25 seconds
        quest::spawn2(1376, 0, 0, $npc->GetX() + 5, $npc->GetY() + 5, $npc->GetZ(), $npc->GetHeading());
    }
}

sub EVENT_DEATH {
    # Stop all timers when the NPC dies
    quest::stoptimer("cast_temporal_rip");
    quest::stoptimer("spawn_minion");
    quest::depopall(1376);  # Depop all minions when the boss dies
}
