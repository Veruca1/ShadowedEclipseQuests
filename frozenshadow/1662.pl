sub EVENT_SPAWN {
    # Ensure the mob is valid
    if (!$npc) {
        quest::shout("ERROR: Mob is undefined during spawn.");
        return;
    }

    # List of buffs to cast
    my @buffs = (12934, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);

    # Apply each buff immediately on spawn
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());
    }

    # Start a timer to recast buffs every 90 seconds
    quest::settimer("recast_buffs", 90);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # In combat
        # Cast "Tempestas Fulgoris!" immediately when aggroed
        quest::shout("Tempestas Fulgoris!");
        if ($npc->GetHateTop()) {
            quest::castspell(40598, $npc->GetHateTop()->GetID());
        }

        # Start a timer to cast it every 20 seconds
        quest::settimer("stun", 20);
    } else {  # Out of combat
        # Stop the stun timer when combat ends
        quest::stoptimer("stun");
    }
}

sub EVENT_TIMER {
    if ($timer eq "stun") {
        # Cast "Tempestas Fulgoris!" every 20 seconds
        quest::shout("Tempestas Fulgoris!");
        if ($npc->GetHateTop()) {
            quest::castspell(40598, $npc->GetHateTop()->GetID());
        }
    }

    if ($timer eq "recast_buffs") {
        # Recast each buff spell
        my @buffs = (12934, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);

        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop the stun and buff recasting timers on death
    quest::stoptimer("stun");
    quest::stoptimer("recast_buffs");
    quest::signalwith(10, 1, 0);
    # Optional: Uncomment and update spawn commands if needed
    # quest::spawn2(1639, 0, 0, 27.88, 140.83, -3.23, 118.75);
}
