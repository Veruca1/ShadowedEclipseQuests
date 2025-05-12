sub EVENT_DEATH_COMPLETE {
    my $npc_id = $npc->GetNPCTypeID();
    my %exploding_npcs = map { $_ => 1 } (
        120049, 120054, 120047, 120026, 120009, 120038, 120070, 120033,
        120023, 120032, 120013, 120109, 120095, 120096, 120075, 120074,
        120104, 120020, 120051, 120022, 120012, 120034, 120027, 120097,
        120082, 120002, 120127, 120040, 120039, 120037, 120060, 120059,
        120058, 120045, 120036, 120103, 120010
    );

    return unless exists $exploding_npcs{$npc_id};  # Skip non-exploding NPCs

    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();
    my $radius = 40;  # Explosion radius

    # Deal damage to players
    foreach my $entity ($entity_list->GetClientList()) {
        if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            $entity->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
            $entity->Damage($npc, 10000, 0, 1, false);  # Damage type 1 (Normal)
        }
    }

    # Deal damage to bots
    foreach my $bot ($entity_list->GetBotList()) {
        if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            #$bot->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
            $bot->Damage($npc, 10000, 0, 1, false);  # Damage type 1 (Normal)
        }
    }

    # Deal damage to pets of players
    foreach my $entity ($entity_list->GetClientList()) {
        my $pet = $entity->GetPet();
        if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            $pet->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
            $pet->Damage($npc, 10000, 0, 1, false);  # Damage type 1 (Normal)
        }
    }

    # Deal damage to pets of bots
    foreach my $bot ($entity_list->GetBotList()) {
        my $pet = $bot->GetPet();
        if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            $pet->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
            $pet->Damage($npc, 10000, 0, 1, false);  # Damage type 1 (Normal)
        }
    }
}
