# List of NPC IDs to cast spells on
my @npc_ids_to_cast = (1516, 1518, 1519);

sub EVENT_SPAWN {
    # Start a repeating timer to check every 10 seconds
    quest::settimer("check_and_cast", 10);
}

sub EVENT_TIMER {
    if ($timer eq "check_and_cast") {
        # Loop through each NPC ID in the list
        foreach my $npc_id (@npc_ids_to_cast) {
            # Find NPC with the current ID in the area
            my $target_npc = $entity_list->GetNPCByNPCTypeID($npc_id);

            # Check if the NPC exists
            if ($target_npc) {
                # Check if the NPC doesn't already have the spell 36938 buff
                if (!$target_npc->FindBuff(36938)) {
                    # Cast spell 36938 on the NPC
                    $npc->CastSpell(36938, $target_npc->GetID());
                }

                # Always cast spell 1469 on the NPC every 10 seconds
                $npc->CastSpell(1469, $target_npc->GetID());
            }
        }
    }
}
