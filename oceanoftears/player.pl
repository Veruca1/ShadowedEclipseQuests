sub EVENT_ENTERZONE {
    my $instver = $instanceversion; # Gets the current instance version

    if (!$client->GetGM() && $client->GetLevel() >= 60 && $instver == 0) {
        $client->Message(15, "You are too powerful to enter this zone! Returning to your bind point.");
        $client->MovePCInstance($client->GetBindZoneID(), 0, $client->GetBindX(), $client->GetBindY(), $client->GetBindZ(), $client->GetBindHeading());
    }
}
