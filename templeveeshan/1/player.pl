sub EVENT_ENTERZONE {
    
    if ($zoneid == 124) {
        # Define the text for the marquee
        my $Text = "You immediately feel a sense of dread, as you hear the laughter or a familiar voice*";

        # Send the marquee message to the player
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $Text);
    }

    quest::signalwith(1910, 1);
}
