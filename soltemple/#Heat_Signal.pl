sub EVENT_SIGNAL {
    if ($signal == 1) {
        # Water NPC coordinates and heading
        my $water_npc = 502002;
        my $water_x = 7.97;
        my $water_y = 537.32;
        my $water_z = 20.06;
        my $water_h = 254.50;
        
        # Earth NPC coordinates and heading
        my $earth_npc = 502000;
        my $earth_x = 6.64;
        my $earth_y = 411.36;
        my $earth_z = 19.88;
        my $earth_h = 510.50;

        # Fire NPC coordinates and heading
        my $fire_npc = 502003;
        my $fire_x = 81.95;
        my $fire_y = 436.06;
        my $fire_z = 20.25;
        my $fire_h = 384.50;
        
        # Air NPC coordinates and heading
        my $air_npc = 502001;
        my $air_x = -68.27;
        my $air_y = 435.40;
        my $air_z = 18.06;
        my $air_h = 130.50;

        # Spawn the NPCs
        quest::spawn2($water_npc, 0, 0, $water_x, $water_y, $water_z, $water_h);
        quest::spawn2($earth_npc, 0, 0, $earth_x, $earth_y, $earth_z, $earth_h);
        quest::spawn2($fire_npc, 0, 0, $fire_x, $fire_y, $fire_z, $fire_h);
        quest::spawn2($air_npc, 0, 0, $air_x, $air_y, $air_z, $air_h);
    }
}

sub EVENT_SPAWN {
   # quest::debug("Heat Signal: im up");
}