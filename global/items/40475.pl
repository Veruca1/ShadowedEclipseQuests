sub EVENT_ITEM_CLICK {
    my $item_id = 40475;

    if ($itemid == $item_id) {
        if ($client->GetAggroCount() > 0) {
            quest::message(314, "You cannot use this while in combat with an enemy.");
            return;
        }

        my $char_id = $client->CharacterID();
        my $bucket_key = "easter_donator_dizzy_$char_id";

        # Set permanent flag
        quest::set_data($bucket_key, 1);

        my $x = $client->GetX();
        my $y = $client->GetY();
        my $z = $client->GetZ();
        my $h = $client->GetHeading();

        quest::spawn2(1967, 0, 0, $x, $y, $z, $h);
        $client->Message(15, "Dizzy appears and offers you teleport options.");
    }
}
