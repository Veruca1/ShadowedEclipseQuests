sub EVENT_ITEM_CLICK {
    my $item_id = 50253;  # ID of the item being clicked

    if ($itemid == $item_id) {  # Check if the clicked item ID matches
        # Check if the player has aggro (is in combat with any NPC)
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
        quest::spawn2(2187, 0, 0, $x, $y, $z, $h);  # Spawn at player's location
        quest::say("Eleven appears and offers you a teleport option.");
    }
}