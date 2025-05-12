sub EVENT_SIGNAL {
    if ($signal == 1) {
     #   quest::debug("Heat signal: spawning mobs");
        
        # Water NPC coordinates and heading
        my $water_npc = 1468;
        my $water_x = -760.23;
        my $water_y = -2045.84;
        my $water_z = -141.18;
        my $water_h = 219.25;
        
        # Earth NPC coordinates and heading
        my $earth_npc = 1469;
        my $earth_x = -695.66;
        my $earth_y = -2167.99;
        my $earth_z = -141.17;
        my $earth_h = 467.25;

        # Fire NPC coordinates and heading
        my $fire_npc = 1470;
        my $fire_x = -648.30;
        my $fire_y = -2069.22;
        my $fire_z = -141.18;
        my $fire_h = 346.25;
        
        # Air NPC coordinates and heading
        my $air_npc = 1471;
        my $air_x = -796.68;
        my $air_y = -2143.89;
        my $air_z = -141.17;
        my $air_h = 87.00;

        # Check and spawn NPCs if not already spawned
        if (!quest::isnpcspawned($water_npc)) {
            quest::spawn2($water_npc, 0, 0, $water_x, $water_y, $water_z, $water_h);
        }
        if (!quest::isnpcspawned($earth_npc)) {
            quest::spawn2($earth_npc, 0, 0, $earth_x, $earth_y, $earth_z, $earth_h);
        }
        if (!quest::isnpcspawned($fire_npc)) {
            quest::spawn2($fire_npc, 0, 0, $fire_x, $fire_y, $fire_z, $fire_h);
        }
        if (!quest::isnpcspawned($air_npc)) {
            quest::spawn2($air_npc, 0, 0, $air_x, $air_y, $air_z, $air_h);
        }
    }
}
