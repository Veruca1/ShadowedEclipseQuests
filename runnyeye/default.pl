sub EVENT_DEATH_COMPLETE {
    # Debugging message to ensure death event triggered
    #quest::shout("NPC has died, starting damage check.");

    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();
    my $radius = 40;  # Explosion radius
    my $damage = 500;  # Damage amount on death

    my %damaged_entities;  # To track entities that have already been damaged

    # Deal damage to players
    foreach my $entity ($entity_list->GetClientList()) {
        if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            # Debug message for players
            #quest::shout("Player $entity has received damage.");

            # Apply damage if not already done
            unless (exists $damaged_entities{$entity}) {
                $entity->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
                $entity->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
                $damaged_entities{$entity} = 1;  # Mark as damaged
            }
        }
    }

    # Deal damage to bots
    foreach my $bot ($entity_list->GetBotList()) {
        if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            # Debug message for bots
            #quest::shout("Bot $bot has received damage.");

            # Apply damage if not already done
            unless (exists $damaged_entities{$bot}) {
                #$bot->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
                $bot->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
                $damaged_entities{$bot} = 1;  # Mark as damaged
            }
        }
    }

    # Deal damage to pets of players
    foreach my $entity ($entity_list->GetClientList()) {
        my $pet = $entity->GetPet();
        if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            # Debug message for pets of players
            #quest::shout("Pet $pet of Player $entity has received damage.");

            # Apply damage if not already done
            unless (exists $damaged_entities{$pet}) {
                $pet->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
                $pet->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
                $damaged_entities{$pet} = 1;  # Mark as damaged
            }
        }
    }

    # Deal damage to pets of bots
    foreach my $bot ($entity_list->GetBotList()) {
        my $pet = $bot->GetPet();
        if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
            # Debug message for pets of bots
            #quest::shout("Pet $pet of Bot $bot has received damage.");

            # Apply damage if not already done
            unless (exists $damaged_entities{$pet}) {
                $pet->Message(14, "As the creature dies, an explosive shockwave erupts, damaging everything nearby!");
                $pet->Damage($npc, $damage, 0, 1, false);  # Damage type 1 (Normal)
                $damaged_entities{$pet} = 1;  # Mark as damaged
            }
        }
    }
}
