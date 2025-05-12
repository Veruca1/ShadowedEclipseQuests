my $respawn_timer = 1800; 
my $last_spawn_time = 0; # Tracks the last time NPC 1649 was spawned
my $port_timer = 0; # Timer for porting the player to their bind location

sub EVENT_SPAWN {
    # Set the proximity range to 10 units in all directions
    quest::set_proximity_range(10, 10);
    quest::debug("NPC 1427 spawned and proximity set.");
}

sub EVENT_ENTER {
    quest::debug("Player entered proximity of NPC 1427.");
    
    # Get the current time
    my $current_time = time();

    # Check if enough time has passed since the last spawn
    if (($current_time - $last_spawn_time) >= $respawn_timer) {
        # Check if NPC 1649 is already spawned in the zone
        my $npc = $entity_list->GetNPCByNPCTypeID(1649);
        if (!$npc) {
            quest::debug("NPC 1649 is not up. Spawning NPC 1649 at ($x, $y, $z, $h).");
            quest::spawn2(1649, 0, 0, $x, $y, $z, $h);
            $last_spawn_time = $current_time; # Update the last spawn time
        } else {
            quest::debug("NPC 1649 is already spawned. Not spawning another instance.");
        }
    } else {
        quest::debug("Proximity trigger ignored. Respawn timer has not elapsed.");
    }
}

sub EVENT_TIMER {
    # Handle porting the player to their bind spot after 1 hour (3600 seconds)
    if ($timer eq "port_bind") {
        # Get the player who killed NPC 1649
        my $client = $npc->GetHateTop();  # The player who is at the top of the hate list (likely the killer)

        # Ensure we have a valid client (player)
        if ($client && $client->IsClient()) {
            # Get the player's bind location
            my $bind_x = $client->GetBindX();
            my $bind_y = $client->GetBindY();
            my $bind_z = $client->GetBindZ();
            my $bind_heading = $client->GetBindHeading();
            
            quest::debug("Porting player ID " . $client->CharacterID() . " to their bind spot.");

            # Port the player to their bind spot
            $client->MovePC(0, $bind_x, $bind_y, $bind_z, $bind_heading);
        } else {
            quest::debug("No valid player found for porting.");
        }

        # Stop the timer once the porting is done
        quest::stoptimer("port_bind");
    }
}
