sub EVENT_ITEM_CLICK {
    # Check if the user has at least 1 of item 43644
    if (quest::countitem(43644) >= 1) {
        # Remove exactly 1 of item 43644
        quest::removeitem(43644, 1);

        # Define possible rewards
        my @possible_rewards = (
            43649, # Blighted Shadowsbane Bracer
            43673, # Blighted Shadowsbane Gauntlet
            43677, # Blighted Shadowsbane Vambraces
            43678, # Blighted Shadowsbane Leggings
            43685, # Blighted Shadowsbane Helm
            43743, # Blighted Shadowsbane Boots
            43747, # Blighted Shadowsbane Chest
        );

        # Pick a random reward
        my $reward = $possible_rewards[int(rand(@possible_rewards))];

        # Give the item to the player
        $client->SummonItem($reward);
    }
}