my $spell_cycle_counter = 0;  # Counter to track spell casting order
my $message_sent_corrupting_strike = 0;
my $message_sent_frenzy = 0;
my $message_sent_ashy_smoke = 0;

sub EVENT_SPAWN {
    quest::settimer("spell_cycle", 30);  # Start spell cycle timer (every 30 seconds)
    quest::shout("What foul place is this?");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat started
        # Reset message flags and counter
        $message_sent_corrupting_strike = 0;
        $message_sent_frenzy = 0;
        $message_sent_ashy_smoke = 0;
        $spell_cycle_counter = 0;

        # Send a marquee message on engagement
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Duskthane, Shade of the Hazy Past, emerges from the lava!");
        }
        quest::settimer("spell_cycle", 30);  # Start or restart the spell cycle timer
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
                # Cast Choking Ashy Smoke
                quest::castspell(36953, $npc->GetID());
                if (!$message_sent_ashy_smoke) {
                    my @client_list = $entity_list->GetClientList();
                    foreach my $client (@client_list) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "A cloud of choking ash escapes from Duskthane’s form!");
                    }
                    $message_sent_ashy_smoke = 1;
                }
                $spell_cycle_counter = 1;
            } elsif ($spell_cycle_counter == 1) {
                # Cast Corrupting Strike II on the target (player or bot)
                quest::castspell(36954, $target->GetID());
                if (!$message_sent_corrupting_strike) {
                    my @client_list = $entity_list->GetClientList();
                    foreach my $client (@client_list) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Duskthane’s strikes are darkened with corruption!");
                    }
                    $message_sent_corrupting_strike = 1;
                }
                $spell_cycle_counter = 2;
            } elsif ($spell_cycle_counter == 2) {
                # Cast Golem Frenzy on himself
                quest::castspell(36955, $npc->GetID());
                if (!$message_sent_frenzy) {
                    my @client_list = $entity_list->GetClientList();
                    foreach my $client (@client_list) {
                        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Duskthane enters a frenzied state, his strikes growing faster and more deadly!");
                    }
                    $message_sent_frenzy = 1;
                }
                $spell_cycle_counter = 0;  # Reset to start the cycle again
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Send a marquee message on death
    my @client_list = $entity_list->GetClientList();
    foreach my $client (@client_list) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Duskthane fades back into the mist, his malevolent presence vanquished. Victory is yours!");
    }
    quest::stoptimer("spell_cycle");  # Stop the spell cycle timer
}
