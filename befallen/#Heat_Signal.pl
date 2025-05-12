sub EVENT_SIGNAL {
    if ($signal == 1) {
      #  quest::debug("Heat signal: spawning mobs");
        # Water NPC coordinates and heading
        my $water_npc = 502002;
        my $water_x = -42.93;
        my $water_y = -793.58;
        my $water_z = -65.90;
        my $water_h = 282.75;
        
        # Earth NPC coordinates and heading
        my $earth_npc = 502000;
        my $earth_x = -41.82;
        my $earth_y = -896.06;
        my $earth_z = -65.64;
        my $earth_h = 481.25;

        # Fire NPC coordinates and heading
        my $fire_npc = 502003;
        my $fire_x = -125.88;
        my $fire_y = -888.88;
        my $fire_z = -65.64;
        my $fire_h = 74.50;
        
        # Air NPC coordinates and heading
        my $air_npc = 502001;
        my $air_x = -110.79;
        my $air_y = -793.83;
        my $air_z = -65.90;
        my $air_h = 174.50;

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