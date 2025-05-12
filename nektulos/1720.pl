sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Ask the player to show the runes
        $client->Message(15, "I need to see the runes you have, traveler. Please show them to me.");
    }
    elsif ($text=~/Spring/i) {
        quest::summonitem(631);  # Reward for Spring (Druidic influence)
        quest::depop();         # Depop NPC
    }
    elsif ($text=~/Summer/i) {
        quest::summonitem(632);  # Reward for Summer (High Dex, Agi)
        quest::depop();          # Depop NPC
    }
    elsif ($text=~/Autumn/i) {
        quest::summonitem(633);  # Reward for Autumn (Caster, High Int, Mana)
        quest::depop();          # Depop NPC
    }
    elsif ($text=~/Winter/i) {
        quest::summonitem(630);  # Reward for Winter (Tank, High AC, HP)
        quest::depop();          # Depop NPC
    }
}

sub EVENT_ITEM {
    # Check if the player has handed in the required runes (626, 627, 628, 629)
    if (plugin::check_handin(\%itemcount, 626 => 1, 627 => 1, 628 => 1, 629 => 1)) {
        # Thank the player and ask about the seasons
        $client->Message(15, "Thank you, traveler. The runes you have brought are exactly what I needed. Now, I must ask you, traveler... " . 
                          quest::saylink("Spring", 1) . ", " . 
                          quest::saylink("Summer", 1) . ", " . 
                          quest::saylink("Autumn", 1) . ", or " . 
                          quest::saylink("Winter", 1) . "?");
    } else {
        # If the player gives incorrect items, return the items
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SPAWN {
    # Spawn the Orc Oracle
    quest::spawn2(1721, 0, 0, 566.32, -468.67, 7.79, 26.25);

    # Spawn the Orc Legionnaire
    quest::spawn2(1722, 0, 0, 447.19, -405.59, 5.67, 70.75);

    # Notify all clients in the zone about the event
    my @clients = $entity_list->GetClientList();  # Get all clients in the zone

    foreach my $client (@clients) {
        if ($client) {  # Check if client exists
            # Send a green message to the client
            $client->Message(14, "You hear the beating of drums from a nearby Orc camp.");
        }
    }
}
