my $phase = 1;

sub EVENT_SPAWN {
    quest::stoptimer("spell_cycle");  # Ensure no timer is running on spawn
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat started
        # Send a marquee message on engagement
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Death Rot Knight begins to unleash his dark powers!");
        }
        quest::settimer("spell_cycle", 10);  # Start spell cycle timer on engagement
    } else {
        quest::stoptimer("spell_cycle");  # Stop the spell cycle timer when combat ends
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cycle") {
        my $hp_ratio = $npc->GetHPRatio();
        my $random_chance = int(rand(100)) + 1;  # Random number between 1 and 100

        # Change phases based on health
        if ($hp_ratio <= 25 && $phase == 1) {
            $phase = 2;
            # Send a marquee message on phase change
            my @client_list = $entity_list->GetClientList();
            foreach my $client (@client_list) {
                $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Death Rot Knight's power surges as he reaches a critical state!");
            }
            quest::settimer("spell_cycle", 5);  # Increase spell cycle frequency
        } elsif ($hp_ratio > 25 && $hp_ratio <= 50 && $phase == 2) {
            $phase = 1;
            # Send a marquee message on phase change
            my @client_list = $entity_list->GetClientList();
            foreach my $client (@client_list) {
                $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Death Rot Knight is weakening and his spells become less frequent.");
            }
            quest::settimer("spell_cycle", 10);  # Reset spell cycle frequency
        }

        # Cast spells based on the current phase
        if ($phase == 1) {
            if ($random_chance <= 50) {  # 50% chance to cast Aura of Decay
                my @clients = $entity_list->GetClientList();
                my $target = $clients[rand @clients];  # Randomly select a player
                if ($target) {
                    $target->CastSpell(31084, $target->GetID());  # Cast Aura of Decay on the selected player
                    my @client_list = $entity_list->GetClientList();
                    foreach my $client (@client_list) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "An oppressive aura surrounds you, lowering your attack power and slowing your strikes!");
                    }
                }
            }
        } elsif ($phase == 2) {
            if ($random_chance <= 30) {  # 30% chance to cast Bone Shield
                quest::castspell(33633, $npc->GetID());
                my @client_list = $entity_list->GetClientList();
                foreach my $client (@client_list) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Death Rot Knight is enveloped in a protective shield, drastically reducing the damage he takes!");
                }
            }
            if ($random_chance <= 20) {  # 20% chance to cast Poison Needle
                my @clients = $entity_list->GetClientList();
                my $target = $clients[rand @clients];  # Randomly select a player
                if ($target) {
                    quest::castspell(4153, $target->GetID());  # Cast Poison Needle on the selected player
                    my @client_list = $entity_list->GetClientList();
                    foreach my $client (@client_list) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Death Rot Knight's Poison Needle strikes, inflicting a poisonous wound!");
                    }
                }
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Send a marquee message on death
    my @client_list = $entity_list->GetClientList();
    foreach my $client (@client_list) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Death Rot Knight's reign of decay has been ended. Victory is yours!");
    }
    quest::stoptimer("spell_cycle");  # Stop the spell cycle timer
}
