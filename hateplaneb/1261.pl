my $phase = 1;
my $spell_cycle_counter = 0;  # Counter to track spell casting order
my $message_sent_corrupting_strike = 0;
my $message_sent_frenzy = 0;
my $message_sent_poison_gas = 0;

sub EVENT_SPAWN {
    quest::settimer("spell_cycle", 10);  # Start spell cycle timer
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat started
        # Reset message flags and counter
        $message_sent_corrupting_strike = 0;
        $message_sent_frenzy = 0;
        $message_sent_poison_gas = 0;
        $spell_cycle_counter = 0;

        # Send a marquee message on engagement
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Fabled Ghoul Lord begins his assault!");
        }
        quest::settimer("spell_cycle", 10);  # Start or restart the spell cycle timer
    } else {
        quest::stoptimer("spell_cycle");  # Stop the spell cycle timer
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cycle") {
        my $hp_ratio = $npc->GetHPRatio();
        my $target = $npc->GetHateTop();  # Get the top hate target (usually a player or bot)

        # Ensure spell casting is based on engagement and there's a valid target
        if ($combat_state == 1 && $target) {
            # Alternate spell casting in a sequence
            if ($spell_cycle_counter == 0) {
                # Cast Poison Gas
                quest::castspell(4162, $npc->GetID());
                if (!$message_sent_poison_gas) {
                    my @client_list = $entity_list->GetClientList();
                    foreach my $client (@client_list) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Poisonous gas seeps from the Fabled Ghoul Lord's wounds!");
                    }
                    $message_sent_poison_gas = 1;
                }
                $spell_cycle_counter = 1;
            } elsif ($spell_cycle_counter == 1) {
                # Cast Corrupting Strike on the target (player or bot)
                quest::castspell(33643, $target->GetID());
                if (!$message_sent_corrupting_strike) {
                    my @client_list = $entity_list->GetClientList();
                    foreach my $client (@client_list) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Fabled Ghoul Lord's strikes are corrupting!");
                    }
                    $message_sent_corrupting_strike = 1;
                }
                $spell_cycle_counter = 2;
            } elsif ($spell_cycle_counter == 2) {
                # Cast Ghoul Frenzy on himself
                quest::castspell(33644, $npc->GetID());
                if (!$message_sent_frenzy) {
                    my @client_list = $entity_list->GetClientList();
                    foreach my $client (@client_list) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Fabled Ghoul Lord enters a frenzied state, his strikes growing faster and draining life!");
                    }
                    $message_sent_frenzy = 1;
                }
                $spell_cycle_counter = 0;
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Send a marquee message on death
    my @client_list = $entity_list->GetClientList();
    foreach my $client (@client_list) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "The Fabled Ghoul Lord's reign of terror has ended. Victory is yours!");
    }
    quest::stoptimer("spell_cycle");  # Stop the spell cycle timer
}
