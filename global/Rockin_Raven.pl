sub EVENT_SPAWN {
	my $owner = $npc->GetOwner();
	return unless $owner;

	my $npc_name = $npc->GetCleanName();

	plugin::pet_spawn_scaling($npc);
	OwnerMessage("Casting Aura of Insight on self and group!");

	# Cast Aura of Insight (spell ID 8939) on the bard itself
	$npc->CastSpell(8926, $npc->GetID());
	# OwnerMessage("Casting Aura of Insight (spell 8926) on NPC: " . $npc->GetName());  # Debugging log for NPC

	# Get the NPC's group
	my $group = $entity_list->GetGroupByMob($npc);
	if ($group) {
		# Cast Aura of Insight (spell ID 8939) on everyone in the group (including bots)
		for (my $i = 0; $i < $group->GroupCount(); $i++) {
			my $member = $group->GetMember($i);
			if ($member && $member->IsClient()) {
				# Cast the aura on each player
				quest::castspell(8939, $member->GetID());
				# OwnerMessage("Casting Aura of Insight (spell 8939) on player: " . $member->GetName());  # Debugging log for player
			}
			elsif ($member && $member->IsBot()) {
				# Cast the aura on each bot as well
				quest::castspell(8939, $member->GetID());
				# OwnerMessage("Casting Aura of Insight (spell 8939) on bot: " . $member->GetName());  # Debugging log for bot
			}
		}
		# OwnerMessage("Casting Aura of Insight on the entire group!");  # Confirmation of group cast
	} else {
		my $owner = $npc->GetOwner();
		return unless $owner;

		$npc->CastSpell(8939, $owner->GetID());
	}
}

sub EVENT_SAY {
	if ($text =~ /insight/i) {
		quest::whisper("Casting Aura of Insight on you and your group!");

		# Cast Aura of Insight (spell ID 8926) on the bard itself
		$npc->CastSpell(8926, $npc->GetID());
		# quest::whisper("Casting Aura of Insight (spell 8926) on NPC: " . $npc->GetCleanName());  # Debugging log for NPC

		# Cast Aura of Insight (spell ID 8939) on the player
		quest::castspell(8939, $client->GetID());
		# quest::whisper("Casting Aura of Insight (spell 8939) on player: " . $client->GetName());  # Debugging log for player

		# Cast Aura of Insight on the player's group members (including bots)
		if ($client->IsGrouped()) {
			my $group = $client->GetGroup();  
			for (my $i = 0; $i < $group->GroupCount(); $i++) {
				my $groupmember = $group->GetMember($i);
				if ($groupmember) {
					# Cast the aura on each group member
					quest::castspell(8939, $groupmember->GetID());
					# quest::whisper("Casting Aura of Insight (spell 8939) on group member: " . $groupmember->GetName());  # Debugging log for group member

					# Cast on their pet if they have one
					my $pet_id = $groupmember->GetPetID();
					if ($pet_id) {
						my $pet = $entity_list->GetMobByID($pet_id);
						if ($pet) {
							quest::castspell(8939, $pet->GetID());
							# quest::whisper("Casting Aura of Insight (spell 8939) on pet of: " . $groupmember->GetName());  # Debugging log for pet
						}
					}
				}
			}
		}

		# Cast Aura of Insight on the player's bots and their pets
		my @npc_list = $entity_list->GetNPCList();  
		foreach my $npc (@npc_list) {
			if ($npc->GetOwnerID() == $client->CharacterID() && $npc->IsBot()) {
				# Cast the aura on each bot
				quest::castspell(8939, $npc->GetID());
				# quest::whisper("Casting Aura of Insight (spell 8939) on bot: " . $npc->GetName());  # Debugging log for bot

				# Cast on their pet if they have one
				my $bot_pet_id = $npc->GetPetID();
				if ($bot_pet_id) {
					my $bot_pet = $entity_list->GetMobByID($bot_pet_id);
					if ($bot_pet) {
						quest::castspell(8939, $bot_pet->GetID());
						# quest::whisper("Casting Aura of Insight (spell 8939) on bot pet: " . $npc->GetName());  # Debugging log for bot pet
					}
				}
			}
		}
	} elsif ($text =~ /offensive/i) {
		quest::whisper("Switching to offensive mode!");
		quest::settimer("bard_offensive", 1); # Start a fast song rotation
		$npc->SetEntityVariable("mode", "offensive");
		$npc->SetEntityVariable("song_index", 0); # Start at the first song
	}
}

sub EVENT_TIMER {
	if ($timer eq "bard_offensive") {
		my $mode = $npc->GetEntityVariable("mode");

		if ($mode eq "offensive") {
			# Offensive song rotation
			my @songs = (5388, 6666, 5384, 5376, 3368); # Offensive song spell IDs
			my $index = $npc->GetEntityVariable("song_index");
			
			# Cast the current song in the rotation
			my $target = $npc->GetHateTop(); # Get the current top hate target
			if ($target) {
				$npc->CastSpell($songs[$index], $target->GetID());
			}
			
			# Update the index for the next song
			$index = ($index + 1) % scalar(@songs); # Loop back to the start if at the end
			$npc->SetEntityVariable("song_index", $index);
		}
	}
}

sub OwnerMessage {
	my $owner = $npc->GetOwner();
	return unless $owner;

	my $npc_name = $npc->GetCleanName();

	my $message = shift;
	$owner->Message(315, "$npc_name whispers, '$message'");
}