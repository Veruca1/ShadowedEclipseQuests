# zone_controller.pl

my @npc_cycle = (157082, 157091, 157077);
my $cycle_index = 0;
my $spawned_npc_id = 0;
my $rotation_paused = 0;

sub EVENT_SPAWN {
    # Start the rotation timer, fire every 10 seconds
    quest::settimer("rotate_npc", 10);

    # Spawn the first NPC in the cycle
    spawn_next_npc();
}

sub EVENT_TIMER {
    if ($timer eq "rotate_npc") {

        # If paused, do nothing
        if ($rotation_paused) {
            return;
        }

        # Depop the currently spawned NPC if one exists
        if ($spawned_npc_id) {
            my $npc = $entity_list->GetNPCByID($spawned_npc_id);
            $npc->Depop() if $npc;
        }

        # Move to the next NPC ID in the cycle
        $cycle_index = ($cycle_index + 1) % scalar(@npc_cycle);

        # Spawn the next NPC in the cycle
        spawn_next_npc();

    } elsif ($timer eq "restart_cycle") {
        quest::debug("Rotation timer restarting after 10 minute pause.");
        $rotation_paused = 0; # Clear pause
        quest::settimer("rotate_npc", 10);
        quest::stoptimer("restart_cycle");
    }
}

sub EVENT_SIGNAL {
    if ($signal == 911) {
        # Stop the rotation timer and pause
        quest::stoptimer("rotate_npc");
        $rotation_paused = 1;
        quest::debug("Rotation stopped due to NPC under attack signal 911. Restart in 10 min.");
        quest::settimer("restart_cycle", 600);

    } elsif ($signal == 900) {
        # Start the restart timer for 10 minutes if a 900 signal comes in
        quest::stoptimer("rotate_npc");
        $rotation_paused = 1;
        quest::debug("Received signal 900. Rotation will restart in 10 min.");
        quest::settimer("restart_cycle", 600);
    }
}

sub spawn_next_npc {
    my $npcid = $npc_cycle[$cycle_index];
    $spawned_npc_id = quest::spawn2($npcid, 0, 0, -1121.53, 620.34, -355.74, 125.75);
}