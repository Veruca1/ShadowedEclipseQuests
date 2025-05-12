sub EVENT_SPAWN {
    $npc->SetFlyMode(1);               # Enable flying
    $npc->MoveTo($npc->GetX(), $npc->GetY(), 50, $npc->GetHeading(), true);  # Adjust Z position
    $npc->SetInvul(1);                 # Make NPC unkillable
    $npc->SetSpecialAbility(20, 1);    # Make uncharmable
    quest::settimer("engage_enemy", 1); # Start a timer to engage the other NPC
}

sub EVENT_TIMER {
    if ($timer eq "engage_enemy") {
        my $enemy_npc = $entity_list->GetNPCByNPCTypeID(1583);  # Target the other NPC
        if ($enemy_npc) {
            $npc->AddToHateList($enemy_npc, 1000);  # Add the enemy to the hate list
            $npc->Attack($enemy_npc);              # Start attacking
        }
    }
}
