sub EVENT_SIGNAL {
    if ($signal == 101) { # Failure / wipe
        # Let zone_controller know the event wiped
        quest::signalwith(10, 20); # 10 = zone_controller, 20 = custom wipe code

        # Depop all the listed NPCs if they are spawned
        my @npc_ids = (1950, 1951, 164118, 164098, 164120);
        foreach my $npc_id (@npc_ids) {
            my $npc = $entity_list->GetNPCByNPCTypeID($npc_id);
            if ($npc) {
                $npc->Depop();
            }
        }    
    }
}