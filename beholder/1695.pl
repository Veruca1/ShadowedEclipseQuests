my $spell_cast_25 = 0;

sub EVENT_SPAWN {
    # List of spell IDs to apply as buffs
    my @buffs = (167, 2177, 161, 649, 2178);

    # Apply buffs to NPC 44133 itself
    foreach my $spell_id (@buffs) {
        $npc->SpellFinished($spell_id, $npc);
    }

    # Set a timer to check health and engagement
    quest::settimer("check_health", 1);
    quest::settimer("check_engagement", 600); # 600 seconds = 10 minutes
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Entering combat
        quest::stoptimer("check_engagement");
        quest::settimer("life_drain", 1);         # Start life drain every second
        quest::settimer("drain_message", 20);    # Start the message timer every 20 seconds

        # Send an initial message at the start of combat
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Boney reaches out for a hero and inadvertently does 500 damage to everyone in the process!");
        }

        # Also notify bots
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "Boney reaches out for a hero and inadvertently does 500 damage to everyone in the process!");
        }

    } elsif ($combat_state == 0) { # Leaving combat
        quest::stoptimer("life_drain");
        quest::stoptimer("drain_message");
        quest::settimer("check_engagement", 600); # Restart depop timer
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_engagement") {
        # Check if NPC has been out of combat
        if ($npc->GetHateList()->IsEmpty()) {
            quest::depop();
        }
    }

    if ($timer eq "check_health") {
        my $health = $npc->GetHP();
        my $max_hp = $npc->GetMaxHP();
        my $health_percent = ($health / $max_hp) * 100;

        if ($health_percent <= 25 && $spell_cast_25 == 0) {
            quest::shout("Oh Look, a flash mob!!");
            for (1..5) {
                quest::spawn2(1696, 0, 0, $x + (rand(10) - 5), $y + (rand(10) - 5), $z, $h);
            }
            $spell_cast_25 = 1;
        }
    }

    if ($timer eq "life_drain") {
        my $npc_x = $npc->GetX();
        my $npc_y = $npc->GetY();
        my $npc_z = $npc->GetZ();
        my $radius = 50;

        foreach my $entity ($entity_list->GetClientList()) {
            my $distance = $entity->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $entity->Damage($npc, 500, 0, 1, false);
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $distance = $bot->CalculateDistance($npc_x, $npc_y, $npc_z);
            if ($distance <= $radius) {
                $bot->Damage($npc, 500, 0, 1, false);
            }
        }

        foreach my $entity ($entity_list->GetClientList()) {
            my $pet = $entity->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 500, 0, 1, false);
                }
            }
        }

        foreach my $bot ($entity_list->GetBotList()) {
            my $pet = $bot->GetPet();
            if ($pet) {
                my $distance = $pet->CalculateDistance($npc_x, $npc_y, $npc_z);
                if ($distance <= $radius) {
                    $pet->Damage($npc, 500, 0, 1, false);
                }
            }
        }
    }

    elsif ($timer eq "drain_message") {
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Boney reaches out for a hero and inadvertently does 500 damage to everyone in the process!");
        }

        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "Boney reaches out for a hero and inadvertently does 500 damage to everyone in the process!");
        }
    }
}