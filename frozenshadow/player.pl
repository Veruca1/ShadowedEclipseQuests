sub EVENT_WARP {
    # Exclude GM players
    if ($client->GetGM()) {  # Use GetGM instead of IsGM
        return;
    }

    # Coordinates for the warp destination
    my $warp_x = 200.35;
    my $warp_y = 139.88;
    my $warp_z = 0.00;
    my $warp_heading = 508.75;

    # Automatically get the instance ID the player is in
    my $instance_id = $client->GetInstanceID();  # Automatically gets the correct instance the player is in

    # Move the player to the desired location in their current instance
    $client->MovePCInstance($zone_id, $instance_id, $warp_x, $warp_y, $warp_z, $warp_heading);

    # Now freeze the player (apply the punishment)
    $client->Freeze();

    # Set a timer to unfreeze the player after 5 seconds (5000 ms)
    quest::settimer("unfreeze", 5);  # "unfreeze" is the timer name
}

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

sub event_click_door {
    my $e = shift;

    # Exclude GM players
    if ($e->self->IsGM()) {
        return;
    }

    my $cur_x = $e->self->GetX();
    my $cur_y = $e->self->GetY();
    my $cur_z = $e->self->GetZ();
    my $dest_x = 0;
    my $dest_y = 0;
    my $dest_z = 0;

    my $door_id = $e->door->GetDoorID();

    # Check if in a raid group
    my $raid = $e->self->GetRaid();
    my $player_list = undef;
    my $player_list_count = undef;
    my $raid_group = undef;

    if ($raid->valid() && $raid->GetGroup($e->self) != -1) {
        $player_list = $raid;
        $player_list_count = $raid->RaidCount();
        $raid_group = $raid->GetGroup($e->self);
    } else {
        # Not in a raid group, check group
        my $group = $e->self->GetGroup();
        if ($group->valid()) {
            $player_list = $group;
            $player_list_count = $group->GroupCount();
        }
    }

    # If there are people in the player list, move them
    if (defined $player_list) {
        if ($door_id == 2 || $door_id == 166) { # First Floor Door
            if ($e->self->KeyRingCheck(20033) || $e->self->HasItem(20033)) {
                $dest_x = 660;
                $dest_y = 100;
                $dest_z = 40;
            }
        } elsif ($door_id == 4 || $door_id == 167) { # Second Floor Door
            if ($e->self->KeyRingCheck(20034) || $e->self->HasItem(20034)) {
                $dest_x = 670;
                $dest_y = 750;
                $dest_z = 75;
            }
        } elsif ($door_id == 16 || $door_id == 165) { # Third Floor Door
            if ($e->self->KeyRingCheck(20035) || $e->self->HasItem(20035)) {
                $dest_x = 170;
                $dest_y = 755;
                $dest_z = 175;
            }
        } elsif ($door_id == 27 || $door_id == 169) { # Fourth Floor Door
            if ($e->self->KeyRingCheck(20036) || $e->self->HasItem(20036)) {
                $dest_x = -150;
                $dest_y = 160;
                $dest_z = 217;
            }
        } elsif ($door_id == 34 || $door_id == 168) { # Fifth Floor Door
            if ($e->self->KeyRingCheck(20037) || $e->self->HasItem(20037)) {
                $dest_x = -320;
                $dest_y = 725;
                $dest_z = 12;
            }
        } elsif ($door_id == 1) { # Sixth Floor Door
            if ($e->self->KeyRingCheck(20038) || $e->self->HasItem(20038)) {
                $dest_x = 20;
                $dest_y = 250;
                $dest_z = 355;
            }
        }

        # Now, if destination is set, port the group members (excluding the initiator)
        if ($dest_x != 0) {
            for (my $i = 0; $i < $player_list_count; $i++) {
                my $mob_v = $player_list->GetMember($i);
                if ($mob_v->valid() && $mob_v->IsClient()) {
                    my $pc = $mob_v->CastToClient();
                    if ($pc->valid()) {
                        if ($pc->CharacterID() != $e->self->CharacterID()) {
                            if (!defined $raid_group || $player_list->GetGroupNumber($i) == $raid_group) {
                                if ($pc->CalculateDistance($cur_x, $cur_y, $cur_z) <= 40) {
                                    $pc->MovePC(111, $dest_x, $dest_y, $dest_z, 0); # Zone: frozenshadow
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
