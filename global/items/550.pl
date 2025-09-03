sub EVENT_ITEM_CLICK {
	# Check if the Minor Coin of Fate (Item ID 550) is in the player's inventory
	if (quest::countitem(550) >= 1) {
		# Remove the Minor Coin of Fate from the player's inventory
		quest::removeitem(550, 1);

		# Send a message to the player
		$client->Message(13, "Minor Coin of Fate used, item consumed. Seek out more from rare spawns.");

		# Randomly determine which effect to trigger (1 to 6)
		my $random_effect = plugin::RandomRange(1, 6);

		# Apply the random effect
		if ($random_effect == 1) {
			# Summon a stack of 20 items (33179)
			$client->SummonItem(33179, 20);
		} elsif ($random_effect == 2) {
			# Summon a stack of 20 items (33180)
			$client->SummonItem(33180, 20);
		} elsif ($random_effect == 3) {
			# Summon a single item (33182)
			$client->SummonItem(33182);
		} elsif ($random_effect == 4) {
			# Summon a single item (43494)
			$client->SummonItem(43494);
		} elsif ($random_effect == 5) {
			# Reduce user's HP to 1
			$client->SetHP(1);
			$client->Message(15, "Your health has been reduced to 1 HP. This is part of a courtesy we like to extend to our most enthusiastic players. Thank you for your non-fiscal patronage.");
		} elsif ($random_effect == 6) {
			# Teleport to Beholder Zone (Zone ID 16) at specified location
			$client->MovePC(16, -387.41, 432.66, -96.22, 281.25);
		}
	} else {
		# If the Minor Coin of Fate is not found
		$client->Message(13, "Minor Coin of Fate not found in your inventory.");
	}
}
