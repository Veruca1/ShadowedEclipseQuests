my $phase = 1;
my $spell_cycle_counter = 0;  # Counter to track spell casting order
my $message_sent_corrupting_strike = 0;
my $message_sent_frenzy = 0;
my $message_sent_poison_gas = 0;
my $message_sent_summon_dire = 0;
my $message_sent_necrotic_infestation = 0;
my $message_sent_deathly_embrace = 0;

sub EVENT_SPAWN {
    quest::settimer("spell_cycle", 10);  # Start spell cycle timer
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat started
        # Reset message flags and counter
        $message_sent_corrupting_strike = 0;
        $message_sent_frenzy = 0;
        $message_sent_poison_gas = 0;
        $message_sent_summon_dire = 0;
        $message_sent_necrotic_infestation = 0;
        $message_sent_deathly_embrace = 0;
        $spell_cycle_counter = 0;

        # Send a marquee message on engagement
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Princess Cherista begins her dark ritual!");
        }
        quest::settimer("spell_cycle", 10);  # Start or restart the spell cycle timer
    } else {
        quest::stoptimer("spell_cycle");  # Stop the spell cycle timer
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cycle") {
        my $hp_ratio = $npc->GetHPRatio();

        # Ensure spell casting is based on engagement
        if ($combat_state == 1) {
            if ($hp_ratio <= 25 && !$message_sent_deathly_embrace) {
                # Cast Deathly Embrace
                quest::castspell(33646, $npc->GetID());
                my @client_list = $entity_list->GetClientList();
                foreach my $client (@client_list) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Princess Cherista wraps herself in deathly energy, reflecting your attacks and draining your essence!");
                }
                $message_sent_deathly_embrace = 1;
            } elsif ($hp_ratio <= 50 && !$message_sent_necrotic_infestation) {
                # Cast Necrotic Infestation
                quest::castspell(36580, $npc->GetID());
                my @client_list = $entity_list->GetClientList();
                foreach my $client (@client_list) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Dark energy seeps into your wounds as Princess Cherista drains your life force!");
                }
                $message_sent_necrotic_infestation = 1;
            } elsif (!$message_sent_summon_dire) {
                # Cast Summon Black Dire
                quest::spawn2(1265, 0, 0, $npc->GetX(), $npc->GetY(), $npc->GetZ(), $npc->GetHeading());
                my @client_list = $entity_list->GetClientList();
                foreach my $client (@client_list) {
                    $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Princess Cherista calls upon the children of the night to aid her!");
                }
                $message_sent_summon_dire = 1;
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Send a marquee message on death
    my @client_list = $entity_list->GetClientList();
    foreach my $client (@client_list) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Princess Cherista's reign of terror has ended. Victory is yours!");
    }
    quest::stoptimer("spell_cycle");  # Stop the spell cycle timer
}
