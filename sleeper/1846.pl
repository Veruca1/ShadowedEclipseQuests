# Define the portal location and NPC ID to spawn
my $portal_loc_x = 493.20;  # X coordinate of the portal
my $portal_loc_y = -8.94;   # Y coordinate of the portal
my $portal_loc_z = 1.25;    # Z coordinate of the portal
my $spawn_heading = 384.00;  # Heading for the spawned NPC 1841
my $npc_id_to_spawn = 1841; # NPC ID 1841 to be spawned

sub EVENT_SPAWN {
    # Start a timer that counts 20 seconds
    quest::settimer("spawn_1841", 20);
}

sub EVENT_TIMER {
    if ($timer eq "spawn_1841") {
        # Calculate the new spawn location, 2 feet in front of the portal (adjusting X coordinate)
        my $new_x = $portal_loc_x + 2.0;  # Moving 2 feet in front of the portal along the X-axis
        
        # Check if NPC 1841 is already spawned
        if (!quest::isnpcspawned($npc_id_to_spawn)) {
            # Spawn NPC 1841 at the calculated location
            quest::spawn2($npc_id_to_spawn, 0, 0, $new_x, $portal_loc_y, $portal_loc_z, $spawn_heading);
        }

        # Stop the timer after spawning NPC 1841
        quest::stoptimer("spawn_1841");
    }
}
