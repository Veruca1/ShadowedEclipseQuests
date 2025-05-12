sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("elf_curse", 5);   # AoE debuff every 5 seconds
        quest::settimer("kreacher_taunt", 30); # Muttering insults every 30 seconds
        
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Kreacher snarls under his breath: 'Filthy half-bloods... Kreacher must fight... Kreacher must obey...'");
        }
    } elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("elf_curse");
        quest::stoptimer("kreacher_taunt");
    }
}

sub EVENT_TIMER {
    my $npc_x = $npc->GetX();
    my $npc_y = $npc->GetY();
    my $npc_z = $npc->GetZ();
    my $radius = 50;  # Effect radius

    if ($timer eq "elf_curse") {
        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                my $stamina_loss = int(rand(20)) + 10; # Randomized stamina drain (10-30)
                my $intellect_loss = int(rand(10)) + 5; # Randomized intellect drain (5-15)
                $entity->Damage($npc, 500, 0, 1, false); # Minor magic damage
                $entity->Message(14, "Kreacher mutters a vile incantation, and you feel your strength wane!");
                $entity->DecreaseStat("stamina", $stamina_loss);
                $entity->DecreaseStat("intelligence", $intellect_loss);
            }
        }
    }
    elsif ($timer eq "kreacher_taunt") {
        my @taunts = (
            "Kreacher grumbles: 'Kreacher serves, but Kreacher does not forget... Filthy, unworthy masters...'",
            "Kreacher sneers: 'Kreacher hates them, yes... But Kreacher must fight...'",
            "Kreacher mutters: 'The bloodline is weak, the house is ruined... But Kreacher endures...'",
            "Kreacher hisses: 'Kreacher will not die so easily, no... Kreacher is smarter than that!'"
        );
        my $random_taunt = $taunts[rand @taunts];

        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, $random_taunt);
        }
    }
}

sub EVENT_HP {
    if ($npc->GetHP() <= ($npc->GetMaxHP() * 0.3) && !defined $qglobals{"kreacher_shield"}) { 
        # Below 30% HP and shield has not been triggered
        quest::setglobal("kreacher_shield", 1, 3, "M10"); # Prevents re-triggering for 10 minutes
        quest::shout("Kreacher cackles: 'You think you can finish Kreacher? Kreacher is stronger than that!'");

        $npc->ModifyNPCStat("ac", $npc->GetAC() * 2); # Doubles AC for 15 seconds
        quest::settimer("shield_off", 15); # Shield wears off after 15 seconds
    }
}

sub EVENT_TIMER {
    if ($timer eq "shield_off") {
        quest::stoptimer("shield_off");
        quest::shout("Kreacher snarls: 'Kreacher tires... but Kreacher still fights!'");
        $npc->ModifyNPCStat("ac", $npc->GetAC() / 2); # Reset AC back to normal
    }
}
sub EVENT_DEATH_COMPLETE {
    
    quest::signalwith(10,6);
}
