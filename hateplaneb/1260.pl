my $phase = 1;

sub EVENT_SPAWN {
    # Do not start the spell cycle timer here
    # Timer will start when the NPC is engaged
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat started
        # Send a marquee message on engagement
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Cmdr Windstream prepares to unleash a cycle of dark power!");
        }
        quest::settimer("spell_cycle", 10);  # Start or restart the spell cycle timer
    } else {
        quest::stoptimer("spell_cycle");  # Stop the spell cycle timer
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cycle") {
        my $hp_ratio = $npc->GetHPRatio();

        # Change phases based on health
        if ($hp_ratio <= 25 && $phase == 1) {
            $phase = 2;
            # Send a marquee message on phase change
            my @client_list = $entity_list->GetClientList();
            foreach my $client (@client_list) {
                $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Fabled Cmdr Windstream's power surges as he reaches a critical state!");
            }
            quest::settimer("spell_cycle", 5);  # Increase spell cycle frequency
        } elsif ($hp_ratio > 25 && $hp_ratio <= 50 && $phase == 2) {
            $phase = 1;
            # Send a marquee message on phase change
            my @client_list = $entity_list->GetClientList();
            foreach my $client (@client_list) {
                $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Fabled Cmdr Windstream is weakening and his spells become less frequent.");
            }
            quest::settimer("spell_cycle", 10);  # Reset spell cycle frequency
        }

        # Cast spells based on the current phase
        if ($phase == 1) {
            # Cast spell 4153
            quest::castspell(4153, $npc->GetID());
            my @client_list = $entity_list->GetClientList();
            foreach my $client (@client_list) {
                $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "A dark shadow envelops the area as The Fabled Cmdr Windstream casts his spell!");
            }
        } elsif ($phase == 2) {
            # Cast spell 4162
            quest::castspell(4162, $npc->GetID());
            my @client_list = $entity_list->GetClientList();
            foreach my $client (@client_list) {
                $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "An eerie wail echoes through the plane as The Fabled Cmdr Windstream casts a devastating spell!");
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Send a marquee message on death
    my @client_list = $entity_list->GetClientList();
    foreach my $client (@client_list) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "As The Fabled Cmdr Windstream's dark power stops. He says, Just go back now while you can");
    }
    quest::stoptimer("spell_cycle");  # Stop the spell cycle timer
}
