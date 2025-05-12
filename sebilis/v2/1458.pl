sub EVENT_AGGRO {
    # Get a list of all clients (players) in the NPC's proximity
    my @clients = $entity_list->GetClientList();

    # Loop through each player and cast spell 2167 (fling) on them
    foreach my $client (@clients) {
        quest::castspell(2167, $client->GetID());
    }

    # Set a timer to cast random spells every 20 seconds
    quest::settimer("cast_spells", 20);
}

sub EVENT_TIMER {
    if ($timer eq "cast_spells") {
        # Randomly choose between spells 1948, 2164, or 36911
        my @spells = (1948, 2164, 36911);
        my $random_spell = $spells[int(rand(@spells))];

        # Get a list of all clients (players) in the NPC's proximity
        my @clients = $entity_list->GetClientList();

        # Loop through each player and cast the randomly chosen spell on them
        foreach my $client (@clients) {
            quest::castspell($random_spell, $client->GetID());
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Sends signal 4 to NPC 1455 with a 2-second delay
    quest::signalwith(1455, 4, 2);
}
