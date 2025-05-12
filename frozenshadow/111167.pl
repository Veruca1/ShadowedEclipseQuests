sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("curse_wave", 5);      # AoE damage every 5 seconds
        quest::settimer("barty_taunt", 30);    # Taunt every 30 seconds
        
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Barty Crouch Jr. sneers: 'Did you really think you had a chance? This will be fun!'");
        }
    } elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("curse_wave");
        quest::stoptimer("barty_taunt");
    }
}

sub EVENT_TIMER {
    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();
    my $radius = 50;  # Damage radius

    if ($timer eq "curse_wave") {
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                my $damage = 750 + int(rand(500)); # Randomized damage between 750-1250
                $entity->Damage($npc, $damage, 0, 1, false);
                $entity->Message(14, "Barty Crouch Jr. flicks his wand, and an eerie curse seeps into your skin!");
            }
        }
    }
    elsif ($timer eq "barty_taunt") {
        my @taunts = (
            "Barty Crouch Jr. grins wickedly: 'Oh, this is just too easy! Try harder!'",
            "Barty Crouch Jr. cackles: 'What's wrong? Are you afraid?'",
            "Barty Crouch Jr. mocks: 'Pathetic! I expected more fight from you!'",
            "Barty Crouch Jr. flicks his wand and smirks: 'You’re about to have a very bad day... hehehe.'"
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