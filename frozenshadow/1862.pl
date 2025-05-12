sub EVENT_SPAWN {
    # Set a proximity range of 20 units
    quest::set_proximity_range(20, 20);
}

sub EVENT_ENTER {
    # Shout the Harry Potter-themed message instead of sending it to the client
    quest::shout("I solemnly swear that I am up to no good!");

    # Ensure full 50,000 damage is applied
    my $hp = $client->GetHP();
    if ($hp > 50000) {
        $client->SetHP($hp - 50000);  # Directly subtract 50K HP
    } else {
        $client->SetHP(0);  # Kill the player if they have less than 50K HP
    }

    # De-spawn the trap after it triggers
    quest::depop();
}
