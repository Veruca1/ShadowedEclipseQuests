sub EVENT_ITEM_CLICK {
    # List of illusion spell IDs
    my @illusions = (
        243,        # Single spell
        581..601    # Range of spells from 581 to 601
    );
    
    # Choose a random spell from the list
    my $random_illusion = $illusions[int(rand(@illusions))];
    
    # Cast the random illusion spell on the player
    $client->CastSpell($random_illusion, $userid);
}
