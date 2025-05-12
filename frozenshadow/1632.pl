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
        # Cast "Glacius Perpetua!" immediately when aggroed
        quest::shout("Glacius Perpetua!");
        if ($npc->GetHateTop()) {
            quest::castspell(40597, $npc->GetHateTop()->GetID());
        }
        
        # Start a timer for subsequent casts every 20 seconds
        quest::settimer("stun", 20);
    }
    else {  # Out of combat
        # Stop the stun timer when combat ends
        quest::stoptimer("stun");
    }
}

sub EVENT_TIMER {
    if ($timer eq "stun") {
        # Cast "Glacius Perpetua!" every 20 seconds
        quest::shout("Glacius Perpetua!");
        if ($npc->GetHateTop()) {
            quest::castspell(40597, $npc->GetHateTop()->GetID());
        }
    }

    if ($timer eq "recast_buffs") {
        # Recast each buff spell every 90 seconds
        my @buffs = (27376, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);
        
        foreach my $spell_id (@buffs) {
            quest::castspell($spell_id, $npc->GetID());
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop the stun and buff recasting timers on death
    quest::stoptimer("stun");
    quest::stoptimer("recast_buffs");

    # Spawn two mobs at the specified location after death (commented out for now)
    #quest::spawn2(1631, 0, 0, 32.94, 357.28, -3.24, 39);
    #quest::spawn2(1632, 0, 0, 94.71, 354.99, -3.24, 471);
    #quest::spawn2(1633, 0, 0, 94.75, 403.31, -3.24, 332.25);
}
