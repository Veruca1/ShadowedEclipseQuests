#Hollen_Shadowstalker_1286.pl

my %zone_data = (
	"Tutorial Mines" => [189, 18.00, -136.32, 16.66],
	"Befallen" => [36, 26.32, -77.27, 2.50],
	"Greater Faydark" => [54, -2180.19, -2175.46, 0.70],
	"Unrest" => [63, 52.00, -38.00, 4.06],
	"Najena" => [44, 849.56, -20.86, 4.06],
	"Plane of Hate" => [186, -374.54, 673.74, 4.06],
	"The Arena" => [77, 144.42, -976.89, 50.85],
	"The Wave Arena" => [492, -15.21, -50.81, -9.87],
	"The Dreadlands" => [86, 9495.46, 781.36, 1065.00],
	"Trakanon" => [95, -4814.08, -1549.92, -470.83],
);

sub EVENT_SAY {
	if ($text =~ /hail/i) {
		my $blessing_link = quest::silent_saylink("blessing");
		quest::whisper("The Omni Device offers you teleport and $blessing_link options:");
		ListTeleports();
	} elsif ($text =~ /blessing/i) {
		quest::whisper("Go forth and rid us of the scourge that is the Shadowed Eclipse!");
		
		# Define the spell IDs to cast
		my @spells = (32165, 61, 60, 63, 64, 138, 174, 278, 457, 161, 160, 152, 153, 5862, 171);

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
			my $buffgroup = $client->GetGroup();  
			if ($buffgroup) {
				for (my $count = 0; $count < $buffgroup->GroupCount(); $count++) {
					my $groupmember = $buffgroup->GetMember($count);
					if ($groupmember) {
						foreach my $spell (@spells) {
							$client->SpellFinished($spell, $groupmember);
						}
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
		my @npc_list = $entity_list->GetNPCList();  
		foreach my $npc (@npc_list) {
			if ($npc->GetOwnerID() == $client->CharacterID() && $npc->IsBot()) {
				foreach my $spell (@spells) {
					$client->SpellFinished($spell, $npc);
				}
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
	} else {
        #Checks to see if a Player is in a Raid or a Group or Solo and teleports the whole Raid/Group if they are apart of one.
		foreach my $zone (sort {$a cmp $b} keys %zone_data) {
			if ($text=~/$zone/i) {
				my ($zone_id, $x, $y, $z) = @{$zone_data{$zone}};
				if ($client->IsRaidGrouped()) {
					my $raid = $client->GetRaid();
					if ($raid) {
						for (my $i = 0; $i < $raid->RaidCount(); $i++) {
							my $member = $raid->GetMember($i);
							if ($member && $member->IsClient()) {
								$member->MovePC($zone_id, $x, $y, $z, 0);
							}
						}
					} else {
						quest::whisper("Error retrieving raid information.");
					}
				} elsif ($client->IsGrouped()) {
					my $group = $client->GetGroup();
					if ($group) {
						$group->TeleportGroup($client, $zone_id, $x, $y, $z, 0);
						$client->MovePC($zone_id, $x, $y, $z, 0); # Teleport the hailer
					} else {
						quest::whisper("Error retrieving group information.");
					}
				} else {
					quest::movepc($zone_id, $x, $y, $z);
				}
			}
		}
	}
}

sub EVENT_TIMER {
	if ($timer eq "depop") {
		quest::depop();
	}
}

sub EVENT_SPAWN {
	quest::settimer("depop", 10);  
}

sub ListTeleports {
	my @teleport_messages = ();

	foreach my $zone (sort {$a cmp $b} keys %zone_data) {
		my $zone_link = quest::silent_saylink($zone);
		push(@teleport_messages, $zone_link);
	}

	my $teleport_message = join(", ", @teleport_messages);

	quest::message(315, $teleport_message);
}