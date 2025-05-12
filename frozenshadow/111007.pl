sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("crush_wave", 5);       # AoE damage every 5 seconds
        quest::settimer("krum_taunt", 30);      # Taunt every 30 seconds
        
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Viktor Krum cracks his knuckles and smirks: 'You think you can best me? I am champion!'");
        }
    } elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("crush_wave");
        quest::stoptimer("krum_taunt");
    }
}

sub EVENT_TIMER {
    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();
    my $radius = 60;  # Damage radius

    if ($timer eq "crush_wave") {
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                my $damage = 900 + int(rand(300)); # Randomized damage between 900-1200
                $entity->Damage($npc, $damage, 0, 1, false);
            }
        }
    }
    elsif ($timer eq "krum_taunt") {
        my @taunts = (
            "Viktor Krum laughs: 'Is this all you have? Pathetic!'",
            "Viktor Krum flexes his muscles: 'You are weak. You should run now!'",
            "Viktor Krum roars: 'You will know pain like never before!'",
            "Viktor Krum glares: 'You think you are strong? I break you like twigs!'"
        );
        my $random_taunt = $taunts[rand @taunts];

        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, $random_taunt);
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    
    quest::signalwith(10,6);
}
