sub EVENT_DEATH_COMPLETE {
    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();
    my $radius = 40;  # Explosion radius

    # Deal damage to players
    foreach my $entity ($entity_list->GetClientList()) {
        if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            $entity->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
            $entity->Damage($npc, 30000, 0, 1, false);  # Normal damage
        }
    }

    # Deal damage to bots
    foreach my $bot ($entity_list->GetBotList()) {
        if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            $bot->Damage($npc, 30000, 0, 1, false);
        }
    }

    # Deal damage to player pets
    foreach my $entity ($entity_list->GetClientList()) {
        my $pet = $entity->GetPet();
        if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            $pet->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
            $pet->Damage($npc, 30000, 0, 1, false);
        }
    }

    # Deal damage to bot pets
    foreach my $bot ($entity_list->GetBotList()) {
        my $pet = $bot->GetPet();
        if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            $pet->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
            $pet->Damage($npc, 30000, 0, 1, false);
        }
    }
}
