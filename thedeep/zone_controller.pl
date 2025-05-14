sub EVENT_SPAWN {
    my $npc_id = 1937;
    my $zone = $zoneid;
    my $instance_ver = $instanceversion;

    if ($zone == 164 && $instance_ver == 1) {
        if (!quest::isnpcspawned($npc_id)) {
            quest::spawn2($npc_id, 0, 0, 719.59, -56.16, 41.41, 73);
        }
    }
}