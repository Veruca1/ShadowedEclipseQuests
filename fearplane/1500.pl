sub EVENT_SPAWN {
    $npc->SetInvul(1);                # Make NPC unkillable
    $npc->SetSpecialAbility(20, 1);   # Uncharmable
    quest::settimer("engage_enemy", 1); # Start a timer
}

sub EVENT_TIMER {
    if ($timer eq "engage_enemy") {
        my $enemy_npc = $entity_list->GetNPCByNPCTypeID(1501); 
        if ($enemy_npc) {
            $npc->AddToHateList($enemy_npc, 1000); # Add hate to NPC 1501
            $npc->Attack($enemy_npc);  # Initiate attack
        }
    }
}
