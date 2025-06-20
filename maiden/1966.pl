sub EVENT_SPAWN {
    # Set special ability 20 (immune to spells)
    $npc->ModifyNPCStat("special_abilities", "20,1");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Start timers with 3 second interval
        quest::settimer("life_drain", 3);
        quest::settimer("drain_message", 3);
    }
    else {
        quest::stoptimer("life_drain");
        quest::stoptimer("drain_message");
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 500;
        my $damage = 13000;

        # Damage clients
        foreach my $entity ($entity_list->GetClientList()) {
            if ($entity->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $entity->Damage($npc, $damage, 0, 1, 0);
            }
        }

        # Damage bots
        foreach my $bot ($entity_list->GetBotList()) {
            if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $bot->Damage($npc, $damage, 0, 1, 0);
            }
        }

        # Damage client pets
        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, $damage, 0, 1, 0);
            }
        }

        # Damage bot pets
        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, $damage, 0, 1, 0);
            }
        }
    }
    elsif ($timer eq "drain_message") {
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(15, "The trapped spirit howls with anguish, draining your life force with a spectral scream!");
        }
    }
}