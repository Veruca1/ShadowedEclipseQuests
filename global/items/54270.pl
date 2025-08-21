sub EVENT_ITEM_CLICK {
    my $item_id = 54270;  # ID of the item being clicked

    if ($itemid == $item_id) {  # Check if the clicked item ID matches
        # Check if the player has aggro
        if ($client->GetAggroCount() > 0) {
            quest::message(314, "You cannot use this while in combat with an enemy.");
            return;
        }

        # If no combat issues, proceed to spawn the NPC
        my $x = $client->GetX();
        my $y = $client->GetY();
        my $z = $client->GetZ();
        my $h = $client->GetHeading();

        # Spawn the NPC that will handle the teleport options at the player's location
        quest::spawn2(2198, 0, 0, $x, $y, $z, $h);  # Spawn at player's location
        quest::say("An Lunar Device appears and offers you teleport options.");
    }
}