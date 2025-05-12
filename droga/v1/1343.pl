# Event NPC (ID: 1343) script

# Counter to track dead NPCs
my $priest_kills = 0;
my $high_priest_id = 1342;
my $incarnate_id = 1340;
my $blindness_spell_id = 9319; # Blinding spell ID

# Fixed coordinates for High Priest and Incarnate Droga
my $fixed_x = 1939.41;
my $fixed_y = 518.86;
my $fixed_z = -270.65;
my $fixed_h = 0;

sub EVENT_SPAWN {
    # Ensure the NPC stays up indefinitely
    quest::settimer("heartbeat", 3600); # 1 hour timer
}

sub EVENT_SIGNAL {
    # Handle signals indicating the death of a Priest (ID: 1341)
    if ($signal == 1) {
        $priest_kills++;
        
        # Debug message to monitor kill count
        #quest::shout("Priest of Droga killed. Current count: $priest_kills");

        # Check if all 8 Priests of Droga have died
        if ($priest_kills >= 8) {
            # Reset the kill counter to avoid multiple spawns
            $priest_kills = 0;
            
            # Trigger screen shake for the High Priest spawn
            $npc->CameraEffect(3000, 6); # 3000ms screen shake
            
            # Spawn High Priest of Droga at the fixed coordinates
            quest::spawn2($high_priest_id, 0, 0, $fixed_x, $fixed_y, $fixed_z, $fixed_h); 
            
            # Debug message to confirm High Priest spawn
            #quest::shout("High Priest of Droga has been spawned at $fixed_x, $fixed_y, $fixed_z.");
        }
    }
    
    # Handle signals indicating the death of the High Priest (ID: 1342)
    if ($signal == 2) {
        # Trigger screen shake for the High Priest's death
        $npc->CameraEffect(3000, 6); # 3000ms screen shake
        
        # Start the blindness effect after 3 seconds
        quest::settimer("blindness", 3); # Wait for 3 seconds before applying blindness
    }
}

sub EVENT_TIMER {
    if ($timer eq "blindness") {
        quest::stoptimer("blindness");  # Stop the blindness timer
        
        # Apply blindness to all players in the zone
        
        quest::castspell($blindness_spell_id, 0);      # Apply blindness spell to players
        
        # Set a timer for the Incarnate Droga spawn 6 seconds after blindness
        quest::settimer("spawn_incarnate", 6); # Wait for 6 seconds before spawning Incarnate Droga
    }
    
    if ($timer eq "spawn_incarnate") {
    quest::stoptimer("spawn_incarnate");  # Stop the spawn timer

    # Check if Incarnate Droga is already spawned
    if (!quest::isnpcspawned($incarnate_id)) {
        # Spawn Incarnate Droga at the fixed location
        quest::spawn2($incarnate_id, 0, 0, $fixed_x, $fixed_y, $fixed_z, $fixed_h); 
        
        # Trigger screen shake for Incarnate Droga spawn
        $npc->CameraEffect(3000, 6);   # 3000ms screen shake
        
        # Debug message to confirm Incarnate Droga spawn
        #quest::shout("Incarnate Droga has been spawned at $fixed_x, $fixed_y, $fixed_z.");
    }
}

sub EVENT_DEATH_COMPLETE {
    # This event is triggered when the High Priest of Droga dies
    quest::signal(1343, 2); # Signal the Event NPC to spawn Incarnate Droga
}
}