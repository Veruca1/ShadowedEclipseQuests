sub EVENT_SPAWN {
    quest::shout("Fresh meat for the ring! You won't last three rounds with me!");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        quest::settimer("taunt", 30);  # Random taunt every 30 seconds
        quest::settimer("drain_message", 20);  # Message every 20 seconds
        
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Bald Bull cracks his knuckles: 'Hope you've been training, rookie!'");
        }
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "Bald Bull cracks his knuckles: 'Hope you've been training, rookie!'");
        }
    } elsif ($combat_state == 0) { # Combat ends
        quest::stoptimer("taunt");
        quest::stoptimer("drain_message");
    }
}

sub EVENT_HP {
    if ($hpevent == 75) {
        quest::shout("Hah! You think you’ve got me figured out? Let’s see you dodge THIS!");
        Perform_Charge();
    }
    elsif ($hpevent == 50) {
        quest::shout("You're looking tired! That’s when I hit hardest!");
        Perform_Charge();
    }
    elsif ($hpevent == 25) {
        quest::shout("Final round! Hope you can take a hit!");
        Perform_Charge();
    }
}

sub EVENT_TIMER {
    if ($timer eq "taunt") {
        my @taunts = (
            "You’re out of your league, little Mac!",
            "Nobody survives the Bull Charge!",
            "I've crushed better fighters than you!",
            "Give up now, or I’ll make you regret it!"
        );

        my $random_taunt = $taunts[rand @taunts];
        quest::shout($random_taunt);
    }
    elsif ($timer eq "drain_message") {
        foreach my $entity ($entity_list->GetClientList()) {
            $entity->Message(14, "Bald Bull continues his relentless assault!");
        }
        foreach my $bot ($entity_list->GetBotList()) {
            #$bot->Message(14, "Bald Bull continues his relentless assault!");
        }
    }
}

sub EVENT_DEATH {
    quest::shout("Nooo! I was just getting warmed up!");
}

sub EVENT_KILLED_MERIT {
    quest::shout("Another victory for the champ! Better luck next time, chump!");
}

sub Perform_Charge {
    foreach my $entity ($entity_list->GetClientList()) {
        $entity->Message(14, "Bald Bull stomps the ground and prepares his devastating Bull Charge!");
        $entity->Damage($npc, 30000, 0, 1, false);
        $npc->DoKnockback($entity, 1000, 1000);
    }

    foreach my $bot ($entity_list->GetBotList()) {
        #$bot->Message(14, "Bald Bull stomps the ground and prepares his devastating Bull Charge!");
        $bot->Damage($npc, 30000, 0, 1, false);
        $npc->DoKnockback($bot, 1000, 1000);

        my $bot_pet = $bot->GetPet();
        if ($bot_pet) {
            $bot_pet->Damage($npc, 30000, 0, 1, false);
            $npc->DoKnockback($bot_pet, 1000, 1000);
        }
    }

    foreach my $entity ($entity_list->GetClientList()) {
        my $pet = $entity->GetPet();
        if ($pet) {
            $pet->Damage($npc, 30000, 0, 1, false);
            $npc->DoKnockback($pet, 1000, 1000);
        }
    }
}