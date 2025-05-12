# Counter to track dead NPCs
my $priest_kills = 0;
my $high_priest_id = 1342;
my $incarnate_id = 1340;
my $blindness_spell_id = 9319; # Blinding spell ID

# Variables to store signal location
my $signal_x;
my $signal_y;
my $signal_z;
my $signal_h;

# Store a unique ID for each NPC that has died
my %unique_priests = ();

sub EVENT_SPAWN {
    # Ensure the NPC stays up indefinitely
    quest::settimer("heartbeat", 3600); # 1 hour timer
}

sub EVENT_SIGNAL {
    # Only proceed if the signal indicates the death of a Priest
    if ($signal == 1) {
        # Use NPC ID or other unique identifier to track this specific priest
        my $npc_id = $npc->GetID();

        # Only count this NPC if it hasn't been counted before
        if (!$unique_priests{$npc_id}) {
            $unique_priests{$npc_id} = 1;
            $priest_kills++;
            
            # Debug message to monitor kill count
            quest::shout("Priest of Droga killed. Current count: $priest_kills");

            # Check if all 8 Priests of Droga have died
            if ($priest_kills >= 8) {
                # Reset the kill counter to avoid multiple spawns
                $priest_kills = 0;
                
                # Trigger screen shake for the High Priest spawn
                $npc->CameraEffect(3000, 6); # 3000ms screen shake
                
                # Spawn High Priest of Droga at the signal location
                quest::spawn2($high_priest_id, 0, 0, $signal_x, $signal_y, $signal_z, $signal_h); # Use captured location
                
                # Debug message to confirm High Priest spawn
                quest::shout("High Priest of Droga has been spawned at $signal_x, $signal_y, $signal_z.");
            }
        }
    }
}

sub EVENT_TIMER {
    if ($timer eq "blindness") {
        quest::stoptimer("blindness");  # Stop the blindness timer
        
        # Apply blindness to all players in the zone
        quest::we(14, "Your vision fades to black!");  # Optional zone-wide message
        quest::castspell($blindness_spell_id, 0);      # Apply blindness spell to players
        
        # Spawn Incarnate Droga at the same location
        quest::spawn2($incarnate_id, 0, 0, $signal_x, $signal_y, $signal_z, $signal_h); # Use the same location
        
        # Trigger screen shake for Incarnate Droga spawn
        $npc->CameraEffect(3000, 6);   # 3000ms screen shake
        
        # Debug message to confirm Incarnate Droga spawn
        quest::shout("Incarnate Droga has been spawned at $signal_x, $signal_y, $signal_z.");
    }
}

sub EVENT_DEATH_COMPLETE {
    # When a priest dies, capture the location of the signal sender
    $signal_x = $x;
    $signal_y = $y;
    $signal_z = $z;
    $signal_h = $h;
    
    # Start the blindness and Incarnate Droga sequence
    quest::settimer("blindness", 2); # Wait for 2 seconds, then blind players
}
