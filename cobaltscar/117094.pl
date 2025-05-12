sub EVENT_SPAWN {
    # Define the buffs you want to apply
    my @buffs = (40601);  # Add spell IDs to the list (e.g., 40601 for runspeed)

    # Apply each buff from the list
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());  # Cast each spell on the NPC itself
    }

    # Ensure NPC is in fly mode to prevent sinking
    $npc->SetFlyMode(1);  # 1 for Fly mode (flying)
    
    # Ensure NPC is running and set its running animation speed to max
    $npc->SetRunning(1);  # Make the NPC run
    $npc->SetRunAnimSpeed(100);  # Set the NPC's run animation speed to a high value (adjust as needed)

    # Set up movement parameters
    quest::set_data("angle_" . $npc->GetID(), rand(360));  # Start at a random angle
    quest::set_data("radius_" . $npc->GetID(), 1600);  # Set the circle radius to a much larger value (4 times bigger)

    # Set up initial position
    quest::set_data("initial_z_" . $npc->GetID(), 624.05);  # Store the initial Z value

    # Start a timer to move the NPC
    quest::settimer("move_in_circle", 1);  # Move every second (adjust as needed)

    # Start a timer for recasting buffs periodically (every 90 seconds)
    quest::settimer("recast_buffs", 90);  # Timer fires every 90 seconds
}

# This will move each NPC in a circle every time the timer triggers
sub EVENT_TIMER {
    my $npc_id = $npc->GetID();  # Get the NPC's unique ID

    # If the timer is for moving in a circle
    if ($timer eq "move_in_circle") {
        my $angle = quest::get_data("angle_$npc_id");  # Get the current angle
        my $radius = quest::get_data("radius_$npc_id");  # Get the circle radius

        # Calculate new position based on angle and radius
        my $new_x = 192.29 + $radius * cos($angle * 3.14159 / 180);
        my $new_y = 33.83 + $radius * sin($angle * 3.14159 / 180);

        my $new_heading = $angle;  # Heading is based on the angle

        # Use the stored Z value to keep the NPC above the water
        my $new_z = quest::get_data("initial_z_" . $npc_id);  # Get the stored initial Z value

        # Move the NPC to the new position while ensuring Z stays constant above water
        $npc->MoveTo($new_x, $new_y, $new_z, $new_heading);  # Z is locked here

        # Update the angle for the next movement
        $angle += 36;  # 36 degrees per step (for 10 NPCs)
        if ($angle >= 360) {
            $angle -= 360;  # Keep the angle within 0-360 range
        }

        # Store the updated angle for the next timer tick
        quest::set_data("angle_$npc_id", $angle);
    }

    # If the timer is for recasting buffs
    if ($timer eq "recast_buffs") {
        # Reapply buffs
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());  # Recast each spell on the NPC
        }
    }
}
