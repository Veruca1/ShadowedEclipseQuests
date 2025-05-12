my $minions_spawned = 0;

sub EVENT_SPAWN {
    # Initialization on spawn, if needed
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat started
        # Send a marquee message to all clients when combat starts
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Rahotep whispers, 'The sands of time have bound me to Xyron’s will. Your flesh will rot, and your soul will be buried beneath the cursed ground of this plane!'");
        }

        quest::settimer("spell_cast", 20);  # Start casting spells every 20 seconds
        quest::settimer("minion_check", 1); # Start checking health every second
    } elsif ($combat_state == 0) {  # Combat ended
        quest::stoptimer("spell_cast");  # Stop casting spells
        quest::stoptimer("minion_check"); # Stop checking health
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cast") {
        my @targets = $entity_list->GetClientList();
        my $target = $targets[int(rand(@targets))]; # Select a random player or bot
        if ($target) {
            # Send a marquee message to all clients for spell cast
            my @client_list = $entity_list->GetClientList();
            foreach my $client (@client_list) {
                $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Rahotep raises his arms and sends a gust of sand in to your eyes!");  # Marquee message for spell cast
            }
            quest::castspell(33642, $target->GetID()); # Cast the Blinding Sands of Ro spell on a random target
        }
    }

    if ($timer eq "minion_check") {
        my $hp_ratio = $npc->GetHPRatio();

        if ($hp_ratio <= 25 && $minions_spawned < 3) {
            Summon_Minions(2);  # Spawn 2 minions
            $minions_spawned = 3;
        } elsif ($hp_ratio <= 50 && $hp_ratio > 25 && $minions_spawned < 2) {
            Summon_Minions(3);  # Spawn 3 minions
            $minions_spawned = 2;
        } elsif ($hp_ratio <= 75 && $hp_ratio > 50 && $minions_spawned < 1) {
            Summon_Minions(2);  # Spawn 2 minions
            $minions_spawned = 1;
        }
    }
}

sub Summon_Minions {
    my ($count) = @_;
    # Send a marquee message to all clients for minion summoning
    my @client_list = $entity_list->GetClientList();
    foreach my $client (@client_list) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "A swarm erupts from Rahotep's mouth!");  # Marquee message for summoning minions
    }
    for (my $i = 0; $i < $count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(1259, 0, 0, $x, $y, $z, $npc->GetHeading());  # Spawn the Deadly Swarm NPC
    }
}

sub EVENT_DEATH_COMPLETE {
    # Send a marquee message to all clients on death
    my @client_list = $entity_list->GetClientList();
    foreach my $client (@client_list) {
        $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "He has made us all his puppets, he must be stopped!");  # Marquee message on death
    }
    quest::stoptimer("spell_cast");
    quest::stoptimer("minion_check");
}
