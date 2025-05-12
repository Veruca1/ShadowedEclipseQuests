sub EVENT_SPAWN {
    # Start the hunt sequence immediately when the NPC spawns
    my @clients = $entity_list->GetClientList();

    # Filter out GM clients
    @clients = grep { !$_->GetGM() } @clients;  

    if (@clients) {
        my $target = $clients[rand @clients];
        $target->Message(15, "You feel like you are being watched");

        # Move towards the target
        quest::moveto($target->GetX(), $target->GetY(), $target->GetZ());

        # Ensure the NPC aggroes the player
        $npc->AddToHateList($target, 10000);
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Start a repeating timer to cast the spell every 10 seconds in combat
        quest::settimer("cast_on_players", 10);
        # Stop the depop timer if it was running
        quest::stoptimer("depop_check");
    } else {
        # Stop the spell-casting timer when combat ends
        quest::stoptimer("cast_on_players");
        # Start a 2-minute timer for depop if out of combat
        quest::settimer("depop_check", 120);
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_on_players") {
        # Get a list of all clients (players and bots) in the zone
        my @targets = $entity_list->GetClientList();

        # Loop through each target within range
        foreach my $target (@targets) {
            if ($npc->CalculateDistance($target->GetX(), $target->GetY(), $target->GetZ()) <= 100) {
                # Cast spell 36945 on the target
                $npc->CastSpell(36945, $target->GetID());
            }
        }
    } elsif ($timer eq "depop_check") {
        # Depop the NPC if it's been out of combat for 2 minutes
        quest::depop();
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop all timers when the NPC dies
    quest::stoptimer("cast_on_players");
    quest::stoptimer("depop_check");
}
