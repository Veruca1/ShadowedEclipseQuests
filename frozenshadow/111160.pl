sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("betrayal_wave", 5);      # AoE dark magic every 5 seconds
        quest::settimer("wormtail_taunt", 30);    # Taunt every 30 seconds
        
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Wormtail stammers: 'P-Please... don't make me do this...!'");
        }
    } elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("betrayal_wave");
        quest::stoptimer("wormtail_taunt");
    }
}

sub EVENT_TIMER {
    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();
    my $radius = 50;  # Damage radius

    if ($timer eq "betrayal_wave") {
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                my $damage = 600 + int(rand(500)); # Randomized damage between 600-1100
                $entity->Damage($npc, $damage, 0, 1, false);
                $entity->Message(14, "Wormtail trembles as dark energy seeps from his wand, striking you with a sinister force!");
            }
        }
    }
    elsif ($timer eq "wormtail_taunt") {
        my @taunts = (
            "Wormtail whimpers: 'D-Don't make me hurt you! I have no choice!'",
            "Wormtail sneers: 'Y-You think you're strong? The Dark Lord rewards loyalty!'",
            "Wormtail cackles nervously: 'You'll regret crossing me! I am... powerful!'",
            "Wormtail pleads: 'P-Perhaps we can talk about this? No? Oh... oh dear...'"
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