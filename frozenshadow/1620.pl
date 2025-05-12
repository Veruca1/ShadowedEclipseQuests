sub EVENT_SPAWN {
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
        # Shout "Reverberum!" immediately when combat begins
        quest::shout("Reverberum!");

        # Start the timer for "Reverberum!" shout every 20 seconds after the initial shout
        quest::settimer("reverberum", 20);

        # Start the nuke timer when combat begins
        quest::settimer("cast_nuke", 20);
    }
    else {  # Out of combat
        # Stop the "Reverberum!" shout timer when combat ends
        quest::stoptimer("reverberum");

        # Stop the nuke timer when combat ends
        quest::stoptimer("cast_nuke");
    }
}

sub EVENT_TIMER {
    if ($timer eq "recast_buffs") {
        # Recast each buff spell
        my @buffs = (20149, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);
        
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());
        }
    }

    if ($timer eq "cast_nuke") {
        # Cast the nuke spell 40596 every 20 seconds
        quest::castspell(40596, $npc->GetID());
    }

    if ($timer eq "reverberum") {
        # Shout "Reverberum!" every time the timer triggers during combat
        quest::shout("Reverberum!");
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop the timers when the NPC dies
    quest::stoptimer("recast_buffs");
    quest::stoptimer("cast_nuke");
    quest::stoptimer("reverberum");
}
