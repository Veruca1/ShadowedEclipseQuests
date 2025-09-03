sub EVENT_ITEM_CLICK {
	if ($itemid == 54270) {  # Check if the clicked item ID matches
		# Check if the player has aggro
		if ($client->GetAggroCount() > 0) {
			quest::message(315, "You cannot use this while in combat with an enemy.");
			return;
		}

		# If no combat issues, proceed to spawn the NPC
		my $x = $client->GetX();
		my $y = $client->GetY();
		my $z = $client->GetZ();
		my $h = $client->GetHeading();

		# Spawn the NPC that will handle the teleport options at the player's location
		quest::spawn2(2198, 0, 0, $x, $y, $z, $h);  # Spawn at player's location
		quest::message(315, "An Lunar Device appears and offers you teleport options.");
	}
}