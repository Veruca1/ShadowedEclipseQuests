# sub EVENT_WARP {
#     # Skip everything if the player is a GM
#     if ($client->GetGM()) {
#         return;
#     }

#     # Coordinates to send warped players
#     my $warp_x = 1783.00;       # X coordinate of the warp destination
#     my $warp_y = -5.00;         # Y coordinate of the warp destination
#     my $warp_z = 15.00;         # Z coordinate of the warp destination
#     my $warp_heading = 0.00;    # Heading for the destination

#     # Get the instance ID the player is in
#     my $instance_id = $client->GetInstanceID();

#     # Move the player in their instance
#     $client->MovePCInstance($zone_id, $instance_id, $warp_x, $warp_y, $warp_z, $warp_heading);

#     # Freeze the player and set a timer to unfreeze
#     $client->Freeze();
#     quest::settimer("unfreeze", 5);
# }

sub EVENT_TIMER {
    if ($timer eq "unfreeze") {
        # Unfreeze the player (end the punishment)
        $client->UnFreeze();

        # Notify the player (optional)
        $client->Message(15, "You have been unfrozen and can continue your journey.");

        # Remove the timer after it is executed
        quest::stoptimer("unfreeze");
    }
}

sub EVENT_CLICKDOOR {
    my $dragonsup = 0;

    # Check if specific NPCs are spawned
    if ($entity_list->IsMobSpawnedByNpcTypeID(108053)) { # Xygoz
        $dragonsup++;
    }
    if ($entity_list->IsMobSpawnedByNpcTypeID(108040)) { # Druushk
        $dragonsup++;
    }
    if ($entity_list->IsMobSpawnedByNpcTypeID(108047)) { # Nexona
        $dragonsup++;
    }
    if ($entity_list->IsMobSpawnedByNpcTypeID(108043)) { # Hoshkar
        $dragonsup++;
    }
    if ($entity_list->IsMobSpawnedByNpcTypeID(108050)) { # Silverwing
        $dragonsup++;
    }

    # Handle door interaction
    if ($doorid == 56 || $doorid == 57) {
        if ($dragonsup == 0) {
            $client->Message(0, "You got the door open.");
            quest::forcedooropen(56);
            quest::forcedooropen(57);
        } else {
            $client->Message(0, "A seal has been placed on this door by Phara Dar. Perhaps there is a way to remove it.");
        }
    }
}
