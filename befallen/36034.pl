sub EVENT_DEATH_COMPLETE {
    # Array of random sayings for skeletons on death
    my @death_messages = (
        "I didn't need those bones anyway!",
        "I'm shattered and broken!",
        "Ouch!",
        "I've got a bone to pick with you!"
    );

    # Select a random message from the array
    my $random_message = $death_messages[int(rand(@death_messages))];

    # Have the skeleton whisper the random message
    quest::whisper($random_message);
}
