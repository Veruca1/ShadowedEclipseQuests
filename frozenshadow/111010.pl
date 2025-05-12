sub EVENT_SPAWN {
    # Reset the "healed" data flag when the NPC spawns
    quest::set_data("healed", 0);

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
        # Start the heal check timer when combat starts
        quest::settimer("heal_check", 10);
    }
    else {  # Out of combat
        # Stop the heal check timer when combat ends
        quest::stoptimer("heal_check");
    }
}

sub EVENT_TIMER {
    if ($timer eq "heal_check") {
        # Check the NPC's current HP percentage
        my $hp_percent = $npc->GetHP() / $npc->GetMaxHP() * 100;

        # Heal the NPC if their HP is 50% or less and they haven't healed yet
        if ($hp_percent <= 50 && !quest::get_data("healed")) {
            # Heal NPC to full HP
            $npc->SetHP($npc->GetMaxHP());  

            # Mark that the NPC has healed
            quest::set_data("healed", 1);  
        }
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
    # Stop the heal check timer and buff recasting timer on death
    quest::stoptimer("heal_check");
    quest::stoptimer("recast_buffs");

    # Reset "healed" data flag to ensure proper healing behavior on respawn
    quest::set_data("healed", 0);

    quest::signalwith(10, 1, 0);
}
