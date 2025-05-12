# NPC: #Aaryonar - NPCID: 2001728

sub EVENT_SPAWN {   
    $npc->CameraEffect(1000, 3);    

    # Get all clients in the zone
    my @clients = $entity_list->GetClientList();

    # Define the text for the marquee
    my $text = "The mighty Aaryonar lives!.";

    # Send the marquee message to each client in the zone
    foreach my $client (@clients) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $text);  # Broadcasting to all players
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Also aggro Kal`Vunar (124016) and Nir`Tan (124012) if they are up
        my @npc_ids = (124012, 124016);
        foreach my $npc_id (@npc_ids) {
            my $npc = $entity_list->GetMobByNpcTypeID($npc_id);
            if ($npc) {
                $npc->AddToHateList($npc->CastToNPC(), 1);
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1911, 400);
}