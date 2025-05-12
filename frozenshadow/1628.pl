sub EVENT_SPAWN {
    # Ensure the mob is valid
    if (!$npc) {
        quest::shout("ERROR: Mob is undefined during spawn.");
        return;
    }

    # List of buffs to cast on spawn
    my @buffs = (20149, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);

    # Apply each buff as a spell
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());
    }

    # Start a timer to recast the buffs every 90 seconds
    quest::settimer("recast_buffs", 90);

    # Set a flag to track which ability to use next
    $npc->SetEntityVariable("next_ability", "relocation");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # In combat
        # Start the timer for alternating between Relocatum and Reverberum every 20 seconds
        quest::settimer("abilities", 20);

        # Start the timer for spawning minions every 15 seconds
        quest::settimer("spawn_minions", 15);
    } else {  # Out of combat
        # Stop timers when combat ends
        quest::stoptimer("abilities");
        quest::stoptimer("spawn_minions");
    }
}

sub EVENT_TIMER {
    if ($timer eq "abilities") {
        # Only perform abilities if in combat
        if ($npc->IsEngaged()) {
            my $next_ability = $npc->GetEntityVariable("next_ability");

            if ($next_ability eq "relocation") {
                # Perform the Relocatum ability
                my @locations = (
                    [346.93, 353.88, -2.35, 380.50],
                    [350.56, 324.36, -2.35, 459.50],
                    [373.15, 324.11, -2.35, 414.00],
                    [372.74, 357.17, -2.35, 372.25],
                    [297.12, 351.44, -2.07, 133.75]
                );

                my $random_location = $locations[int(rand(@locations))];
                $npc->GMMove($random_location->[0], $random_location->[1], $random_location->[2], $random_location->[3]);
                quest::shout("Relocatum!");

                # Set the next ability to Reverberum
                $npc->SetEntityVariable("next_ability", "reverberum");
            } else {
                # Perform the Reverberum ability (cast a nuke)
                my $target = $npc->GetTarget();
                if ($target) {
                    quest::shout("Reverberum!");
                    quest::castspell(40596, $target->GetID());
                }

                # Set the next ability to Relocatum
                $npc->SetEntityVariable("next_ability", "relocation");
            }
        }
    }

    if ($timer eq "recast_buffs") {
        # Recast each buff spell every 90 seconds
        my @buffs = (20149, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());
        }
    }

    if ($timer eq "spawn_minions") {
        # Spawn a minion (NPC 1623) at the NPC's current location
        if ($npc->IsEngaged()) {
            quest::spawn2(1623, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop timers when the NPC dies
    quest::stoptimer("abilities");
    quest::stoptimer("recast_buffs");
    quest::stoptimer("spawn_minions");

    # Generate a random number between 1 and 100
    my $chance = int(rand(100)) + 1;

    # Determine which NPC to spawn (25% chance for NPC 1642, otherwise NPC 1630)
    my $npc_id = ($chance <= 25) ? 1642 : 1630;

    # Spawn the chosen NPC at the specified location after death
    quest::spawn2($npc_id, 0, 0, 63.61, 415.19, -3.24, 510.25);
}

