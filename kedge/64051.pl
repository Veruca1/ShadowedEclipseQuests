sub EVENT_SPAWN {
    # Start a repeating timer to check every 10 seconds
    quest::settimer("check_and_cast", 10);
}

sub EVENT_TIMER {
    if ($timer eq "check_and_cast") {
        # Find NPC with ID 1505 in the area
        my $npc_1505 = $entity_list->GetNPCByNPCTypeID(1505);

        # Check if NPC 1505 exists
        if ($npc_1505) {
            # Check if NPC 1505 doesn't already have the spell 36938 buff
            if (!$npc_1505->FindBuff(36938)) {
                # Cast spell 36938 on NPC 1505
                $npc->CastSpell(36938, $npc_1505->GetID());
            }

            # Always cast spell 1469 on NPC 1505 every 10 seconds
            $npc->CastSpell(1469, $npc_1505->GetID());
        }
    }
}
