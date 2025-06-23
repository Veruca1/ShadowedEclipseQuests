sub EVENT_AGGRO {
    $client->Message(14, "I am indestructable!");
}

sub EVENT_COMBAT {
    # Check if NPC has entered combat
    if ($combat_state == 1) {
        # Start a repeating timer to check health every second
        quest::settimer("check_hp", 1);
    } else {
        # Stop the timer when combat ends
        quest::stoptimer("check_hp");
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_hp") {
        # Check if NPC's health is at or below 50%
        if ($npc->GetHPRatio() <= 50) {
            # Make the NPC immune to ranged and magic attacks
            $npc->SetSpecialAbility(46, 1); # Ranged immunity
            #$npc->SetSpecialAbility(20, 1); # Magic immunity if desired
            # NPC shouts a message
            #$npc->Shout("Don't be shy now, come here!");
            # Stop further checks to prevent re-triggering
            quest::stoptimer("check_hp");
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Spawn NPC 1518 at the specified location upon death
    my $existing = $entity_list->GetNPCByNPCTypeID(1518);
    $existing->Depop(1) if $existing;

    quest::spawn2(1518, 0, 0, -45.87, -1.22, 2.86, 123.75);
}