sub EVENT_SPAWN {
    quest::signalwith(1911, 899);
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("life_drain", 38);
    } elsif ($combat_state == 0) {
        quest::stoptimer("life_drain");
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;

        # Damage clients
        foreach my $client ($entity_list->GetClientList()) {
            if ($client->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $client->Damage($npc, 35000, 0, 1, false);
            }

            # Damage their pets
            my $pet = $client->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, 35000, 0, 1, false);
            }
        }

        # Damage bots
        foreach my $bot ($entity_list->GetBotList()) {
            if ($bot->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $bot->Damage($npc, 35000, 0, 1, false);
            }

            # Damage their pets
            my $pet = $bot->GetPet();
            if ($pet && $pet->CalculateDistance($npc_x, $npc_y, $npc_z) <= $radius) {
                $pet->Damage($npc, 35000, 0, 1, false);
            }
        }
    }
}

sub EVENT_DAMAGE_TAKEN {
    my ($attacker, $damage) = @_;
    return $damage;
}

sub EVENT_DEATH_COMPLETE {
    quest::spawn2(1595, 0, 0, -1166.82, 1861.11, 169.18, 387.75);
    quest::spawn2(1594, 0, 0, -1175.27, 1800.26, 170.36, 388.50);
    quest::spawn2(1595, 0, 0, -1172.91, 1740.11, 167.41, 389.75);
}