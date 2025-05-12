my $minions_spawned = 0;
my $spawn_timer_started = 0;  # Track whether the spawn timer has been started

sub EVENT_SPAWN {
    quest::settimer("check_buffs", 1);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("spell_cast", 60);  # Set spell casting every 60 seconds
        quest::settimer("check_hp", 1);  # Start checking health during combat
        $npc->Attack($npc->GetHateTop());  # Re-engage attack on top hated target
        
        # Start the minion spawn timer if it hasn't started
        if (!$spawn_timer_started) {
            quest::settimer("spawn_minion", 40);  # Start minion spawning every 40 seconds
            $spawn_timer_started = 1;  # Set flag to indicate the spawn timer has started
        }
    } elsif ($combat_state == 0) {
        quest::stoptimer("spell_cast");  # Stop spell casting when combat ends
        quest::stoptimer("check_hp");  # Stop health checks when combat ends
        quest::stoptimer("spawn_minion");  # Stop minion spawning when combat ends
        $minions_spawned = 0;  # Reset the minion spawn flag
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        $npc->CastSpell(12879, $npc->GetID()) if !$npc->FindBuff(12879);
    }

    if ($timer eq "spell_cast") {
        $npc->CastSpell(36946, $npc->GetID());
        $npc->Attack($npc->GetHateTop());  # Re-engage attack after casting
    }

    if ($timer eq "check_hp") {
        my $hp_ratio = $npc->GetHPRatio();

        if ($hp_ratio <= 80 && $hp_ratio > 75 && !$minions_spawned) {
            # Shout "Seek and Destroy!" once when health drops to 80%
            $npc->Shout("Seek and Destroy!");
            $minions_spawned = 1;  # Set flag to prevent multiple shouts
        }

        # Minion spawn logic should only happen once every 40 seconds
        if ($hp_ratio <= 80 && $minions_spawned && !$spawn_timer_started) {
            quest::spawn2(1580, 0, 0, -724.35, -239.64, 442.58, 0.00);  # Spawn minion once
            $spawn_timer_started = 1;  # Ensure only one spawn happens initially
        }
    }

    if ($timer eq "spawn_minion") {
        quest::spawn2(1580, 0, 0, -724.35, -239.64, 442.58, 0.00);  # Spawn minion every 40 seconds
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("spell_cast");
    quest::stoptimer("check_hp");  # Stop health checks on death
    quest::stoptimer("spawn_minion");  # Stop minion spawning on death
    $minions_spawned = 0;  # Reset the minion spawn flag
    quest::signalwith(1427, 32, 2);  # Sends signal 1 to NPC ID 1427
}
