sub EVENT_SPAWN {
    quest::shout("BEWARE! I LIVE");
    $npc->CameraEffect(3000, 6);
    quest::settimer("depop_machine", 300);
}

sub EVENT_TIMER {
    if ($timer eq "depop_machine") {
        quest::shout("You have run out of time!");
        quest::depop_withtimer();

        # Check if the NPC is already up to prevent duplicate spawns
        my $npc_id = 36105;
        my $npc_spawned = quest::isnpcspawned($npc_id);
        
        if (!$npc_spawned) {
            # If the NPC is not up, spawn it at the specified location
            $spawn_x = -88.91;
            $spawn_y = -332.17;
            $spawn_z = -12.02;
            $spawn_h = 437.75;
            quest::spawn2($npc_id, 0, 0, $spawn_x, $spawn_y, $spawn_z, $spawn_h);
        }

        quest::stoptimer("depop_machine");
    }
}
