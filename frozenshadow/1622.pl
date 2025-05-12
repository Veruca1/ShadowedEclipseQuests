sub EVENT_SPAWN {
    # List of buffs to cast on spawn
    my @buffs = (20149, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);

    # Apply each buff as a spell
    foreach my $spell_id (@buffs) {
        quest::castspell($spell_id, $npc->GetID());
    }

    # Start a timer to recast the buffs every 90 seconds
    quest::settimer("recast_buffs", 90);

    # Start a timer to cast the nuke (spell 40596) every 20 seconds
    quest::settimer("cast_nuke", 20);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # In combat
        # Shout "Reverberum!" immediately when combat begins
        quest::shout("Reverberum!");

        # Start the timer for "Reverberum!" shout every 20 seconds after the initial shout
        quest::settimer("reverberum", 20);

        # Start the timer for spawning minions every 15 seconds
        quest::settimer("spawn_minions", 15);
    }
    else {  # Out of combat
        # Stop the "Reverberum!" shout timer when combat ends
        quest::stoptimer("reverberum");

        # Stop the minion spawn timer when combat ends
        quest::stoptimer("spawn_minions");
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
        # Only cast the nuke if the NPC is in combat
        if ($npc->IsEngaged()) {
            quest::castspell(40596, $npc->GetID());
        }
    }

    if ($timer eq "reverberum") {
        # Shout "Reverberum!" every time the timer triggers during combat
        quest::shout("Reverberum!");
    }

    if ($timer eq "spawn_minions") {
        # Spawn a minion (NPC 1623) at the NPC's current location
        quest::spawn2(1623, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop timers when the NPC dies
    quest::stoptimer("recast_buffs");
    quest::stoptimer("cast_nuke");
    quest::stoptimer("reverberum");
    quest::stoptimer("spawn_minions");

    # Spawn NPCs 1620 and 1621 at the specified locations
    #quest::spawn2(1618, 0, 0, 170.25, 404.27, -2.79, 269.25);
    quest::spawn2(1624, 0, 0, 202.04, 408.69, -3.14, 264.00);

    # Send the marquee message to all clients in the zone
    my @clients = $entity_list->GetClientList();
    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 3000, "You hear a shrill loud scream come from the main room");
    }
}
