sub EVENT_WARP {
    # Exclude GM players
    if ($client->GetGM()) {
        return;
    }

    # Kill the player as punishment for warping
    $client->Kill();
}

sub EVENT_ENTERZONE {
    if ($zoneid == 124 && $instanceversion == 1) {
        # Define the text for the marquee
        my $Text = "You immediately feel a sense of dread, as you hear the laughter of a familiar voice*";

        # Send the marquee message to the player
        $client->SendMarqueeMessage(15, 510, 1, 1, 8000, $Text);
    }

    quest::signalwith(1911, 1);
}