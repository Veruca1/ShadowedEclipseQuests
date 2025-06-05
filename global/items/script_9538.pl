sub EVENT_ITEM_CLICK {
    # Validate the client object to prevent null pointer issues
    return unless $client && $client->IsClient();

    # Define a hash to map item IDs to AA points and messages
    my %aa_rewards = (
        9538 => { points => 1,   message => "1 AA added!" },
        9539 => { points => 10,  message => "10 AA added!" },
        9540 => { points => 25,  message => "25 AA added!" },
        9541 => { points => 50,  message => "50 AA added!" },
        9542 => { points => 75,  message => "75 AA added!" },
        9543 => { points => 100, message => "100 AA added!" },
        9544 => { points => 500, message => "500 AA added!" },
        150101 => { points => 5000, message => "5000 AA added!" },
        150102 => { points => 50000, message => "500000 AA added!" },
    );

    # Check if the item clicked is in the aa_rewards hash
    if (exists $aa_rewards{$itemid}) {
        my $reward = $aa_rewards{$itemid};
        $client->AddAAPoints($reward->{points});
        $client->Message(21, $reward->{message});
        $client->RemoveItem($itemid, 1);
    } else {
        $client->Message(13, "This item does not have any effect.");
    }
}
