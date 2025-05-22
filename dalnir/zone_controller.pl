sub EVENT_SPAWN {
    # First attempt to depop all NPCs with ID 1461
    my @npcs = $entity_list->GetNPCList();
    foreach my $npc (@npcs) {
        if ($npc->GetNPCTypeID() == 1461) {
            $npc->Depop();
        }
    }

    # Set a timer to try again in 1 second
    quest::settimer("depop_retry", 1);
}

sub EVENT_TIMER {
    if ($timer eq "depop_retry") {
        quest::stoptimer("depop_retry");

        # Second attempt to depop all NPCs with ID 1461
        my @npcs = $entity_list->GetNPCList();
        foreach my $npc (@npcs) {
            if ($npc->GetNPCTypeID() == 1461) {
                $npc->Depop();
            }
        }
    }
}