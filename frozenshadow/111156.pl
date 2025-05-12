sub EVENT_SPAWN {
    # Set a proximity range of 20 units
    quest::set_proximity_range(20, 20);
}

sub EVENT_ENTER {
    # Display a Harry Potter-themed message to the player
    $client->Message(15, "I guess this isn't really disabled, it strikes you with a deadly curse. 'Meddle not with what lies beyond!'");

    # Deal 50,000 unresistable damage to the player
    $client->Damage($client, 50000, 111100, 0, true);

    # De-spawn the trap after it triggers
    quest::depop();
}
