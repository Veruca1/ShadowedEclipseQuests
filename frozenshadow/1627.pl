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
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # In combat
        # Start the relocation timer when combat starts
        quest::settimer("relocation", 10);

        # Shout the relocation phrase when combat begins
        quest::shout("Relocatum!");
    }
    else {  # Out of combat
        # Stop the relocation timer when combat ends
        quest::stoptimer("relocation");
    }
}

sub EVENT_TIMER {
    if ($timer eq "relocation") {
        # Select a random location from the list
        my @locations = (
            [346.93, 353.88, -2.35, 380.50],
            [350.56, 324.36, -2.35, 459.50],
            [373.15, 324.11, -2.35, 414.00],
            [372.74, 357.17, -2.35, 372.25],
            [297.12, 351.44, -2.07, 133.75]
        );
        
        my $random_location = $locations[int(rand(@locations))];

        # Teleport npc to the selected location (with heading)
        $npc->GMMove($random_location->[0], $random_location->[1], $random_location->[2], $random_location->[3]);

        # Shout the relocation phrase
        quest::shout("Relocatum!");
    }

    if ($timer eq "recast_buffs") {
        # Recast each buff spell every 90 seconds
        my @buffs = (20149, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);
        
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop the relocation timer and buff recasting timer on death
    quest::stoptimer("relocation");
    quest::stoptimer("recast_buffs");

    # Spawn two mobs at the specified location after death
    quest::spawn2(1628, 0, 0, 342.38, 427.35, -3.23, 368.50);
    
}
