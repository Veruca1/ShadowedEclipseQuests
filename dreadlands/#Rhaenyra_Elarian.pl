sub EVENT_SAY {
	if ($text=~/hail/i) {
		my $blessing_link = quest::silent_saylink("blessing");
		quest::whisper("Hello, adventurer! I can offer you buffs to help you on your adventure. Just say [$blessing_link] when you are ready.");
	} if ($text=~/blessing/i) {
		quest::whisper("Go forth and rid us of the scourge that is the Shadowed Eclipse!");

		# Define the spell IDs to cast
		my @spells = (3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);

		# Cast spells on the player
		foreach my $spell (@spells) {
			$client->SpellFinished($spell, $client);
		}

		$client->RestoreEndurance();
		$client->RestoreHealth();
		$client->RestoreMana();

		# Cast spells on the player's pet
		my $client_pet = $client->GetPet();
		if ($client_pet) {
			foreach my $spell (@spells) {
				$client->SpellFinished($spell, $client_pet);
			}

			$client_pet->RestoreEndurance();
			$client_pet->RestoreHealth();
			$client_pet->RestoreMana();
		}

		# Cast spells on the entire group
		if ($client->IsGrouped()) {
			my $buffgroup = $client->GetGroup();  # Retrieve the group object
			if ($buffgroup) {
				# Loop through group members and apply spells
				for (my $count = 0; $count < $buffgroup->GroupCount(); $count++) {
					my $member = $buffgroup->GetMember($count);
					if ($member && $member->IsClient()) {
						# Cast spells on each group member
						foreach my $spell (@spells) {
							$client->SpellFinished($spell, $member);
						}

						$member->RestoreEndurance();
						$member->RestoreHealth();
						$member->RestoreMana();

						# Cast spells on each group member's pet
						my $member_pet = $member->GetPet();
						if ($member_pet) {
							foreach my $spell (@spells) {
								$client->SpellFinished($spell, $member_pet);
							}

							$client_pet->RestoreEndurance();
							$client_pet->RestoreHealth();
							$client_pet->RestoreMana();
						}
					}
				}
			} else {
				quest::whisper("Error retrieving group information.");
			}
		}

		# Cast spells on the player's bots and their pets
		my @bots = $entity_list->GetBotListByCharacterID($client->CharacterID());  # Retrieve all NPCs in the zone
		foreach my $bot (@bots) {
			foreach my $spell (@spells) {
				$client->SpellFinished($spell, $bot);
			}

			$bot->RestoreEndurance();
			$bot->RestoreHealth();
			$bot->RestoreMana();

			# Cast spells on the bot's pet if it has one
			my $bot_pet = $bot->GetPet();
			if ($bot_pet) {
				$client->SpellFinished($spell, $bot_pet);

				$bot_pet->RestoreEndurance();
				$bot_pet->RestoreHealth();
				$bot_pet->RestoreMana();
			}
		}
	}
}
