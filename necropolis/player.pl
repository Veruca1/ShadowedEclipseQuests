sub EVENT_ENTERZONE {
    # Check if the player is entering Necropolis (Zone ID 123)
    if ($zoneid == 123) {
        # Define the text for the marquee
        my $Text = "As you enter, you increasingly feel more creeped out. As if you are being watched. *You hear a noise from above*";

        # Send the marquee message to the player
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $Text);
    }
}