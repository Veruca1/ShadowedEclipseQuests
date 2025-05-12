sub EVENT_ENTERZONE {
    # Set the player's bind point to their current location
    $client->SetBindPoint(58, 0, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());

    # Send a whisper message to the player to confirm they've been soulbound
    quest::whisper("You have been soulbound to this zone!");
}
