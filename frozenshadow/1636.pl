sub EVENT_SPAWN {
    # Ensure the mob is valid
    if (!$npc) {
        quest::shout("ERROR: Mob is undefined during spawn.");
        return;
    }

    # List of buffs to cast on spawn
    my @buffs = (12934, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);

    # Apply each buff as a spell
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());
    }

    # Start a timer to recast the buffs every 90 seconds
    quest::settimer("recast_buffs", 90);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # In combat
        # Start the stun timer when combat starts
        quest::settimer("stun", 20);
    }
    else {  # Out of combat
        # Stop the stun timer when combat ends
        quest::stoptimer("stun");
    }
}

sub EVENT_TIMER {
    if ($timer eq "stun") {
        # Cast the lightning spell (Chaotic Lightning Zap)
        quest::shout("Tempestas Fulgoris!");
        quest::castspell(40598, $npc->GetHateTop()->GetID()) if $npc->GetHateTop();
    }

    if ($timer eq "recast_buffs") {
        # Recast each buff spell every 90 seconds
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

    # Optional: Uncomment and update spawn commands if needed
    #quest::spawn2(1636, 0, 0, 51.38, 259.54, -2.38, 133.25);
    #quest::spawn2(1637, 0, 0, 79.50, 289.00, -2.38, 320.25);
}
