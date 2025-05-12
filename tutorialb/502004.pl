sub EVENT_SIGNAL {
    if ($signal == 1) {
       # quest::debug("#quest::debug: spawning mobs");
        # Water NPC coordinates and heading
        my $water_npc = 1233;
        my $water_x = 129.10;
        my $water_y = -281.16;
        my $water_z = -5.50;
        my $water_h = 405.25;
        
        # Earth NPC coordinates and heading
        my $earth_npc = 1234;
        my $earth_x = -42.83;
        my $earth_y = -349.15;
        my $earth_z = -5.50;
        my $earth_h = 405.25;

        # Fire NPC coordinates and heading
        my $fire_npc = 1235;
        my $fire_x = -84.78;
        my $fire_y = -208.58;
        my $fire_z = -5.50;
        my $fire_h = 171.25;
        
        # Air NPC coordinates and heading
        my $air_npc = 1236;
        my $air_x = 47.77;
        my $air_y = -169.93;
        my $air_z = -5.50;
        my $air_h = 307.25;

        # Spawn the NPCs
        quest::spawn2($water_npc, 0, 0, $water_x, $water_y, $water_z, $water_h);
        quest::spawn2($earth_npc, 0, 0, $earth_x, $earth_y, $earth_z, $earth_h);
        quest::spawn2($fire_npc, 0, 0, $fire_x, $fire_y, $fire_z, $fire_h);
        quest::spawn2($air_npc, 0, 0, $air_x, $air_y, $air_z, $air_h);
    }
}

sub EVENT_SPAWN {
   # quest::debug("#quest::debug: im up");

}