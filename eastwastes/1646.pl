sub EVENT_SPAWN {
    # Set timers for checking buffs and spawning adds
    quest::settimer("check_buffs", 1);
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        # Cast spell 27376 on the NPC itself if it doesn't already have it
        $npc->CastSpell(27376, $npc->GetID()) if !$npc->FindBuff(27376);
        # Restart the timer for buff checking every 1 second
        quest::settimer("check_buffs", 1);
    }
    elsif ($timer eq "spawn_adds") {
        # Spawn three NPCs with ID 1647 at the NPC's current location
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Spawn 3 adds around the NPC
        quest::spawn2(1647, 0, 0, $x + 5, $y + 5, $z, $h);
        quest::spawn2(1647, 0, 0, $x - 5, $y - 5, $z, $h);
        quest::spawn2(1647, 0, 0, $x, $y, $z + 5, $h);
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has entered combat, start spawn adds timer
        quest::settimer("spawn_adds", 25); # Timer to spawn adds every 25 seconds
    } elsif ($combat_state == 0) {
        # NPC has left combat, stop spawn adds timer
        quest::stoptimer("spawn_adds");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Send SIGNAL 1 to the zone controller with NPC ID 724075
    quest::signalwith(10, 1, 0); # Signal 1, no delay
}
