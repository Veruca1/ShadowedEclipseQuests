sub EVENT_SPAWN {
    # Ensure the mob is valid
    if (!$npc) {
        quest::shout("ERROR: Mob is undefined during spawn.");
        return;
    }

    # List of buffs to cast on spawn
    my @buffs = (27376, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);

    # Apply each buff as a spell
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());
    }

    # Start a timer to recast the buffs every 90 seconds
    quest::settimer("recast_buffs", 90);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # In combat
        # Start the ability rotation timer every 10 seconds
        quest::settimer("abilities", 10);

        # Start the minion spawn timer every 15 seconds
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
            # Randomly choose an ability to execute
            my $ability = int(rand(3));
            if ($ability == 0) {
                # Relocatum: Teleports to a random location
                my @locations = (
                    [63.61, 415.19, -3.24, 510.25],
                    [330.99, 234.53, -0.17, 381.25],
                    [327.16, 349.07, -0.32, 386.50],
                    [91.54, 423.43, -3.24, 508.75],
                    [202.04, 408.69, -3.14, 264.00]
                );
                my $random_location = $locations[int(rand(@locations))];
                $npc->GMMove($random_location->[0], $random_location->[1], $random_location->[2], $random_location->[3]);
                quest::shout("Relocatum!");
            } elsif ($ability == 1) {
                # Reverberum: Cast a nuke spell on the target
                my $target = $npc->GetTarget();
                if ($target) {
                    quest::shout("Reverberum!");
                    quest::castspell(40596, $target->GetID());
                }
            } else {
                # Glacius Perpetua: Cast a stun spell on the target
                my $target = $npc->GetHateTop();
                if ($target) {
                    quest::shout("Glacius Perpetua!");
                    quest::castspell(40597, $target->GetID());
                }
            }
        }
    }

    if ($timer eq "recast_buffs") {
        # Recast each buff spell every 90 seconds
        my @buffs = (20149, 27376, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);
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

    # Determine which NPC to spawn (25% chance for NPC 1643, otherwise NPC 1635)
    my $npc_id = ($chance <= 25) ? 1643 : 1635;

    # Spawn the chosen NPC at the specified location after death
    quest::spawn2($npc_id, 0, 0, 90.35, 259.69, -2.11, 130.25);
}