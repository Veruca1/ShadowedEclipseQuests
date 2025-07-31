sub EVENT_SPAWN {
    return unless $npc;

    $npc->SetNPCFactionID(0);

    $npc->ModifyNPCStat("level", 100);
    $npc->ModifyNPCStat("ac", 30000);
    $npc->ModifyNPCStat("max_hp", 9000000);
    $npc->ModifyNPCStat("hp_regen", 2500);
    $npc->ModifyNPCStat("mana_regen", 10000);
    $npc->ModifyNPCStat("min_hit", 100000);
    $npc->ModifyNPCStat("max_hit", 200000);
    $npc->ModifyNPCStat("atk", 3000);
    $npc->ModifyNPCStat("accuracy", 1900);
    $npc->ModifyNPCStat("avoidance", 105);
    $npc->ModifyNPCStat("attack_delay", 4);
    $npc->ModifyNPCStat("attack_speed", 100);
    $npc->ModifyNPCStat("slow_mitigation", 85);
    $npc->ModifyNPCStat("attack_count", 100);
    $npc->ModifyNPCStat("heroic_strikethrough", 90);
    $npc->ModifyNPCStat("aggro", 57);
    $npc->ModifyNPCStat("assist", 1);

    $npc->ModifyNPCStat("str", 1100);
    $npc->ModifyNPCStat("sta", 1100);
    $npc->ModifyNPCStat("agi", 1100);
    $npc->ModifyNPCStat("dex", 1100);
    $npc->ModifyNPCStat("wis", 1100);
    $npc->ModifyNPCStat("int", 1100);
    $npc->ModifyNPCStat("cha", 900);

    $npc->ModifyNPCStat("mr", 350);
    $npc->ModifyNPCStat("fr", 350);
    $npc->ModifyNPCStat("cr", 350);
    $npc->ModifyNPCStat("pr", 350);
    $npc->ModifyNPCStat("dr", 350);
    $npc->ModifyNPCStat("corruption_resist", 400);
    $npc->ModifyNPCStat("physical_resist", 900);

    $npc->ModifyNPCStat("runspeed", 2);
    $npc->ModifyNPCStat("trackable", 1);
    $npc->ModifyNPCStat("see_invis", 1);
    $npc->ModifyNPCStat("see_invis_undead", 1);
    $npc->ModifyNPCStat("see_hide", 1);
    $npc->ModifyNPCStat("see_improved_hide", 1);

    $npc->ModifyNPCStat("special_abilities", "12,1^13,1^14,1^15,1^16,1^17,1^31,1^18,1^35,1^26,1^28,1^19,1^20,1^21,1^23,1^22,1^24,1^25,1^46,1");

    my $max_hp = $npc->GetMaxHP();
    $npc->SetHP($max_hp) if defined $max_hp && $max_hp > 0;
}

sub EVENT_SAY {
	if ($text=~/hail/i) {
		my $blessing_link = quest::silent_saylink("blessing");
		my $power_source_link = quest::silent_saylink("Power Source");
		quest::whisper("Hello, adventurer! I can offer you two services. You can either receive a [$blessing_link] to aid you on your journey, or you can upgrade your [$power_source_link]. Which would you like?");
	} if ($text=~/blessing/i) {
		quest::whisper("Go forth and rid us of the scourge that is the Shadowed Eclipse!");

		# Define the spell IDs to cast
		my @spells = (2602, 3842, 13, 161, 160, 152, 153, 171, 174, 278, 4053, 5862, 138, 61, 60, 457, 63, 64);

		# Cast spells on the player
		foreach my $spell (@spells) {
			$client->SpellFinished($spell, $client);
		}

		# Cast spells on the player's pet
		my $pet_id = $client->GetPetID();
		if ($pet_id) {
			my $pet = $entity_list->GetMobByID($pet_id);
			foreach my $spell (@spells) {
				$client->SpellFinished($spell, $pet);
			}
		}

		# Cast spells on the entire group
		if ($client->IsGrouped()) {
			my $buffgroup = $client->GetGroup();  # Retrieve the group object
			if ($buffgroup) {
				# Loop through group members and apply spells
				for (my $count = 0; $count < $buffgroup->GroupCount(); $count++) {
					my $groupmember = $buffgroup->GetMember($count);
					if ($groupmember) {
						# Cast spells on each group member
						foreach my $spell (@spells) {
							$client->SpellFinished($spell, $groupmember);
						}

						# Cast spells on each group member's pet
						my $groupmember_pet_id = $groupmember->GetPetID();
						if ($groupmember_pet_id) {
							my $groupmember_pet = $entity_list->GetMobByID($groupmember_pet_id);
							foreach my $spell (@spells) {
								if ($groupmember_pet) {
									$client->SpellFinished($spell, $groupmember_pet);
								}
							}
						}
					}
				}
			} else {
				quest::whisper("Error retrieving group information.");
			}
		}

		# Cast spells on the player's bots and their pets
		my @npc_list = $entity_list->GetNPCList();  # Retrieve all NPCs in the zone
		foreach my $npc (@npc_list) {
			if ($npc->GetOwnerID() == $client->CharacterID() && $npc->IsBot()) {
				foreach my $spell (@spells) {
					$client->SpellFinished($spell, $npc);
				}

				# Cast spells on the bot's pet if it has one
				my $bot_pet_id = $npc->GetPetID();
				if ($bot_pet_id) {
					my $bot_pet = $entity_list->GetMobByID($bot_pet_id);
					foreach my $spell (@spells) {
						if ($bot_pet) {
							$client->SpellFinished($spell, $bot_pet);
						}
					}
				}
			}
		}
	} elsif ($text=~/Power Source/i) {
		quest::whisper("If you bring me your Holy Source of Power, along with an Upgrade Stone, I can attempt to enhance it for you. Be aware that the chance of success decreases as the item rank increases. If you fail, the Holy Source will NO LONGER lose a rank because you all cried too hard. Are you ready to upgrade?");
	}
}

sub EVENT_ITEM {
	# Upgrade Stone ID
	my $upgrade_stone = 17732;

	# Define rank items
	my %ranks = (
		0 => 17731,  # Starting item
		1 => 147690, # Rank +1
		2 => 147691, # Rank +2
		3 => 147692, # Rank +3
		4 => 147693, # Rank +4
		5 => 147694, # Rank +5
		6 => 147695, # Rank +6
		7 => 147696, # Rank +7
		8 => 147697, # Rank +8
		9 => 147698, # Rank +9
		10 => 147699, # Rank +10
	);

	# Define success chances for each rank
	my %success_chances = (
		0 => 100,  # 100% success chance to go from Rank 0 to Rank 1
		1 => 90,   # 90% success chance to go from Rank 1 to Rank 2
		2 => 80,   # 80% success chance to go from Rank 2 to Rank 3
		3 => 70,   # 70% success chance to go from Rank 3 to Rank 4
		4 => 60,   # 60% success chance to go from Rank 4 to Rank 5
		5 => 50,   # 50% success chance to go from Rank 5 to Rank 6
		6 => 40,   # 40% success chance to go from Rank 6 to Rank 7
		7 => 30,   # 30% success chance to go from Rank 7 to Rank 8
		8 => 20,   # 20% success chance to go from Rank 8 to Rank 9
		9 => 10,   # 10% success chance to go from Rank 9 to Rank 10
	);

	# Loop through the ranks to check which item the player has handed in
	foreach my $rank (sort { $a <=> $b } keys %ranks) {
		my $item_id = $ranks{$rank};
		my $next_rank = $rank + 1;

		# Check if player handed in the correct rank item and upgrade stone
		if (plugin::check_handin(\%itemcount, $item_id => 1, $upgrade_stone => 1)) {
			if (exists $ranks{$next_rank}) {
				# Get the success chance for the current rank
				my $success_chance = $success_chances{$rank};
				my $random_number = int(rand(100)) + 1;

				if ($random_number <= $success_chance) {
					# Success: Give the next rank item
					quest::whisper("Congratulations! Your item has been upgraded to Rank $next_rank.");
					quest::summonitem($ranks{$next_rank});
				} else {
					# Failure: Notify the player of the failure and return the item
			quest::whisper("The upgrade attempt failed.");
			quest::summonitem($item_id);  # Return the original item back to the player

				}
			} else {
				quest::whisper("Your item is already at the maximum rank.");
				quest::summonitem($item_id);  # Return the item if it's already at the maximum rank
			}
			return;
		}
	}

	# If the player handed in incorrect items, return them
	quest::whisper("These items cannot be upgraded. Please hand in a valid item and an Upgrade Stone.");
	plugin::return_items(\%itemcount);
}