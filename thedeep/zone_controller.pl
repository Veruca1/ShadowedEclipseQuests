my @npc_ids = (1941, 1942, 1943, 1944);
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

    if ($zone == 164 && $instance_ver == 1) {
        if (!quest::isnpcspawned($npc_id)) {
            #quest::spawn2($npc_id, 0, 0, 719.59, -56.16, 41.41, 73);
        }
    }

    # Zigzag logic init
    @active_npcs = @npc_ids;
    $engaged = 0;
    $current_npc_eid = 0;
    quest::settimer("zigzag", 8);
}

sub EVENT_TIMER {
    return if $engaged || !@active_npcs;

    if ($timer eq "zigzag") {
        # Depop previous if exists
        if ($current_npc_eid && $entity_list->GetNPCByID($current_npc_eid)) {
            $entity_list->GetNPCByID($current_npc_eid)->Depop();
            $current_npc_eid = 0;
        }

        # Pick and spawn next NPC
        my $npc_id = $active_npcs[int(rand(@active_npcs))];
        my $loc = $spawn_points[int(rand(@spawn_points))];
        $current_npc_eid = quest::spawn2($npc_id, 0, 0, @$loc);
    }
}

sub EVENT_SIGNAL {
    if ($signal == 250) {
        $engaged = 1;
        quest::stoptimer("zigzag");
    } elsif ($signal >= 1000 && $signal <= 1003) {
        my $dead_npc_id = 1941 + ($signal - 1000);
        @active_npcs = grep { $_ != $dead_npc_id } @active_npcs;
        $engaged = 0;
        $current_npc_eid = 0;
        if (@active_npcs) {
            quest::settimer("zigzag", 8);
        }
    }
}