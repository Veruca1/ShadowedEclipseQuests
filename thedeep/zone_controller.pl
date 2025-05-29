my @npc_ids = (1941, 1942, 1943, 1944); # Mini-bosses
my @spawn_points = (
    [338.67, -337.53, -59.20, 448.25],
    [1260.49, 873.12, -61.22, 111.75],
    [2685.94, -1016.83, -52.28, 383.75],
    [1377.30, -333.38, -57.26, 33.50],
    [-87.42, 703.63, -58.08, 506.50],
    [2461.90, 624.86, -59.46, 113.00],
);

my @active_npcs;
my $engaged = 0;
my $current_npc_eid = 0;

sub EVENT_SPAWN {
    my $npc_id = 1937;
    my $zone = $zoneid;
    my $instance_ver = $instanceversion;

    # Only spawn NPC 1937 in version 1 (not open world)
    if ($zone == 164 && $instance_ver == 1) {
        my $is_spawned = quest::isnpcspawned($npc_id);

        plugin::Debug("isnpcspawned($npc_id) returned $is_spawned");

        if (!$is_spawned) {
            plugin::Debug("Spawning NPC 1937...");
            quest::spawn2($npc_id, 0, 0, 719.59, -56.16, 41.41, 73);
        } else {
            plugin::Debug("Duplicate prevented: 1937 already exists");
        }
    }

    # Spawn the sub-controller in open world only
    if ($instance_ver == 0) {
        quest::spawn2(164120, 0, 0, 1627.08, 276.63, -57.33, 316.75);
    }

    @active_npcs = @npc_ids;
    $engaged = 0;
    $current_npc_eid = 0;

    quest::settimer("zigzag", 8);
}

sub EVENT_TIMER {
    if ($timer eq "zigzag") {
        return if $engaged || !@active_npcs;

        # Despawn old mini if it's still up
        if ($current_npc_eid) {
            my $prev_npc = $entity_list->GetNPCByID($current_npc_eid);
            $prev_npc->Depop() if defined $prev_npc;
        }

        # Pick random mini and spawn point
        my $npc_id = $active_npcs[int(rand(@active_npcs))];
        my $index = int(rand(scalar(@spawn_points)));

        if (ref($spawn_points[$index]) eq 'ARRAY') {
            my ($x, $y, $z, $h) = @{ $spawn_points[$index] };
            $current_npc_eid = quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
        } else {
            quest::shout("ERROR: Spawn point at index $index is invalid.");
        }
    }

    # Removed wipe_monitor timer block entirely

    elsif ($timer eq "spawn_controller") {
        quest::spawn2(164120, 0, 0, 1627.08, 276.63, -57.33, 316.75);
        quest::spawn2(164098, 0, 0, 1773.90, -17.83, -85.55, 248.75);
        quest::stoptimer("spawn_controller");
    }
    elsif ($timer eq "spawn_controller_success") {
    quest::spawn2(164120, 0, 0, 1627.08, 276.63, -57.33, 316.75);
    quest::stoptimer("spawn_controller_success");
}
}

sub EVENT_SIGNAL {
    if ($signal == 250) {
        $engaged = 1;
        quest::stoptimer("zigzag");
    }
    elsif ($signal == 20) {
        # Full reset after a wipe: spawn both NPCs
        quest::settimer("spawn_controller", 300); # spawns 164120 and 164098
    }
    elsif ($signal == 30) {
        # Raid success: only spawn controller
        quest::settimer("spawn_controller_success", 300); # spawns only 164120
    }
    elsif ($signal >= 1000 && $signal <= 1003) {
        my $dead_npc_id = 1941 + ($signal - 1000);
        @active_npcs = grep { $_ != $dead_npc_id } @active_npcs;
        $engaged = 0;
        $current_npc_eid = 0;

        if (@active_npcs) {
            quest::settimer("zigzag", 8);
        } else {
            # All mini-bosses dead, spawn final boss
            quest::spawn2(1947, 0, 0, 2287.70, -999.23, -59.20, 398);
        }
    }
}