# Rematch section
my %rematches = (
	"Statue of Rallos Zek" => { npc_id => 1757, loc => [1380.10, 2763.43, -64.37, 254.25] },
	"Derakor the Vindicator" => { npc_id => 1756, loc => [1284.57, 1356.26, -97.17, 0] },
	"Overseer Hragveld Frostbane" => { npc_id => 1758, loc => [1294.06, 987.16, -94.36, 0] },
);

sub EVENT_ITEM {
	my $char_id = $client->CharacterID();
	my $flag = "$char_id-kael_arena_flag";

	# Check if the player handed in both required items (669 - Price of Admission, 670 - Proof of Skill)
	if (plugin::check_handin(\%itemcount, 669 => 1, 670 => 1)) {
		my $ready_to_rumble_link = quest::silent_saylink("READY TO RUMBLE");
		quest::set_data($flag, 1);
		
		# Set client variable for event access (making sure the player has access)
		$client->SetGlobal("kael_arena_access", 1, 5, "F");

		# Broadcast the message to the world
		quest::we(14, $name . " Paid the price of admission and shown the skill needed to enter Kael Drakkel’s **RUMBLE FOR GLORY**!");
		
		quest::whisper("Ladies and gentlemen, warriors of legend, we have a **CONTENDER!** You have earned your place in the arena! When you're ready to face your fate, hail me and click $ready_to_rumble_link!");
	} 
	# Rematch Handin Logic
	elsif (plugin::check_handin(\%itemcount, 672 => 1)) {
		quest::set_data("$char_id-rematch-1757", 1);
		quest::whisper("You've earned a rematch with the mighty Statue of Rallos Zek! Hail me when you're ready.");
	} elsif (plugin::check_handin(\%itemcount, 673 => 1)) {
		quest::set_data("$char_id-rematch-1756", 1);
		quest::whisper("You've earned a rematch with Derakor the Vindicator! Hail me when you're ready.");
	} elsif (plugin::check_handin(\%itemcount, 674 => 1)) {
		quest::set_data("$char_id-rematch-1758", 1);
		quest::whisper("You've earned a rematch with Overseer Hragveld Frostbane! Hail me when you're ready.");
		$client->EnableTitle(405);  # Correct: grant the title to just this player
		$client->Message(15, "You have earned the title 'Heavyweight Champion of Kael'!");
		quest::we(13, "$name has defeated Frostbane's Overseer, and earned the title Heavyweight Champion of Kael!"); # Announce title in orange
		quest::discordsend("titles", "$name has earned the title of Heavyweight Champion of Kael!");
	}

	plugin::return_items(\%itemcount);
}

sub EVENT_SAY {
	my $char_id = $client->CharacterID();
	my $flag = "$char_id-kael_arena_flag";
	my $cooldown_key = "$char_id-kael_arena_cooldown";
	my $cooldown_time = 30;  # 30 second cooldown

	if ($text =~ /hail/i) {
		if (quest::get_data($flag)) {
			my $ready_to_rumble_link = quest::silent_saylink("READY TO RUMBLE");
			quest::whisper("**ARE YOU READY?!** Are you **really** ready? If so, click $ready_to_rumble_link and prepare for the fight of your life!");
		} else {
			quest::whisper("Sorry, kid! This is the **big leagues**, and stepping into the ring doesn't come cheap! It takes **proof of your skill** AND a **hefty price of admission** to earn your shot at glory!");
		}
		
		ListRematches($char_id);
	} elsif ($text =~ /ready to rumble/i) {
		if (quest::get_data($flag)) {
			my $last_attempt_time = quest::get_data($cooldown_key);
			my $current_time = time();

			if (!$last_attempt_time || ($current_time - $last_attempt_time) > $cooldown_time) {
				quest::set_data($cooldown_key, $current_time);

				quest::whisper("**LET'S GET READY TO RUMBLEEEEEE!!!**");

				# Shake the camera for a dramatic effect!
				$npc->CameraEffect(3000, 6);

				# List of NPCs to spawn (1765, 1766, 1767, 1768)
				my @npc_ids = (1765, 1766, 1767, 1768);

				# List of locations where NPCs should spawn (17 locations)
				my @locations = (
					[1291.02, 1813.98, -37.20, 258.00],
					[1198.76, 1787.22, -37.18, 125.50],
					[1373.44, 1792.36, -37.20, 382.00],
					[1386.18, 1922.89, -37.20, 259.50],
					[1383.57, 2142.29, -37.20, 257.75],
					[1379.33, 2391.57, -37.19, 263.00],
					[1455.80, 2339.20, -37.19, 390.25],
					[1288.10, 2339.43, -37.19, 134.75],
					[1295.80, 2450.69, -37.20, 256.75],
					[1382.02, 2437.25, -37.20, 7.00],
					[1469.21, 2466.83, -37.20, 392.50],
					[1380.12, 2481.10, -37.20, 254.75],
					[1420.53, 2562.57, -37.21, 247.00],
					[1339.37, 2565.59, -37.20, 261.50],
					[1430.24, 2589.67, -76.24, 386.25],
					[1326.23, 2589.32, -76.24, 135.25],
					[1493.87, 2710.25, -76.24, 392.50],
					[1269.57, 2709.90, -76.23, 130.50]
				);

				# Spawn NPC at each location using any of the 4 NPC IDs (1765, 1766, 1767, 1768)
				my $location_index = 0;
				foreach my $loc (@locations) {
					# Randomly select an NPC ID for each location
					my $npc_id = $npc_ids[int(rand(scalar(@npc_ids)))];
					quest::spawn2($npc_id, 0, 0, @$loc);
					$location_index++;
				}
			} else {
				my $remaining_time = $cooldown_time - ($current_time - $last_attempt_time);
				quest::whisper("You're eager, I love it! But you've gotta wait just a little longer! **Time remaining:** " . int($remaining_time / 60) . " minutes, " . ($remaining_time % 60) . " seconds.");
			}
		} else {
			quest::whisper("You may have the heart of a warrior, but you still need to **prove yourself** before stepping into the arena!");
		}
	}

	foreach my $npc_name (keys %rematches) {
		if ($text =~ /$npc_name/i) {
			my $npc_id = $rematches{$npc_name}->{npc_id};
			my $cooldown_key = "$char_id-rematch-cooldown-$npc_id";
			my $last_attempt_time = quest::get_data($cooldown_key);
			my $current_time = time();

			if (!$last_attempt_time || ($current_time - $last_attempt_time) > 30) {
				quest::set_data($cooldown_key, $current_time);
				my ($x, $y, $z, $h) = @{$rematches{$npc_name}->{loc}};
				quest::spawn2($npc_id, 0, 0, $x, $y, $z, $h);
				quest::whisper("$npc_name has been summoned! Prepare yourself!");
			} else {
				my $remaining_time = quest::secondstotime(30 - ($current_time - $last_attempt_time));
				quest::whisper("You must wait another $remaining_time before your next rematch.");
			}
		}
	}
}

sub EVENT_SIGNAL {
	my $char_id;

	# Attempt to retrieve a player from the NPC's hate list (if in combat)
	if ($npc->GetHateTop()) {
		my $top_hate = $npc->GetHateTop();
		$char_id = $top_hate->CastToClient()->CharacterID() if $top_hate && $top_hate->IsClient();
	}
	
	# If no hate list player, find a random client in the zone
	if (!$char_id) {
		my $random_client = $entity_list->GetRandomClient();
		$char_id = $random_client->CharacterID() if $random_client;
	}

	# If still no valid player, exit early
	if (!$char_id) {
		quest::whisper("Error: No valid player found for tracking signal 7.");
		return;
	}

	# Signal 1: Play-by-Play Announcements
	if ($signal == 1) {
		$signal_count++;

		if ($signal_count == 4) {
			quest::shout("The crowd is getting restless! Who will fall first?");
		} elsif ($signal_count == 7) {
			quest::shout("It’s turning into a real slugfest out there!");
		} elsif ($signal_count == 10) {
			quest::shout("Ohh! That had to hurt! They’re giving it their all!");
		} elsif ($signal_count == 15) {
			quest::shout("This fight is far from over! Who will emerge victorious?");
		} elsif ($signal_count >= 18) {
			quest::spawn2(1757, 0, 0, 1380.10, 2763.43, -64.37, 254.25);
			$npc->CameraEffect(2000, 3);
			quest::shout("Lightweight Title Bout!!!! - Ladies and Gentlemen, Introducing, The Statue of Rallos Zek!");
			$signal_count = 0;
		}
	}

	# Signal 2: Spawn Random NPCs
	elsif ($signal == 2) {
		my @npc_ids = (1772, 1773, 1774, 1775);
		my @locations = (
			[1275.94, 2650.42, -76.68], [1109.40, 2659.07, -76.94],
			[1119.72, 2507.68, -77.19], [929.28, 2521.32, -77.18],
			[922.35, 2570.07, -77.18], [854.53, 2517.95, -77.18],
			[920.88, 2268.25, -77.18], [919.49, 2027.84, -77.17],
			[1094.47, 2039.11, -91.60], [1036.80, 1969.62, -97.20],
			[1037.22, 1748.74, -97.16], [1040.02, 1605.76, -97.18],
			[1192.84, 1621.74, -97.17], [1290.31, 1619.45, -97.17],
			[1284.57, 1356.26, -97.17], [1287.99, 1240.67, -93.98]
		);

		foreach my $loc (@locations) {
			my $npc_id = $npc_ids[int(rand(scalar(@npc_ids)))];
			quest::spawn2($npc_id, 0, 0, @$loc, 0);
		}
	}

	# Signal 3: More Play-by-Play Announcements
	elsif ($signal == 3) {
		$signal_3_count++;

		if ($signal_3_count == 1) {
			quest::shout("What a battle! Neither side is backing down!");
		} elsif ($signal_3_count == 4) {
			quest::shout("The hits just keep coming! Can they keep this pace up?");
		} elsif ($signal_3_count == 12) {
			quest::shout("What a display of endurance! They're refusing to go down!");
		} elsif ($signal_3_count == 15) {
			quest::shout("Unbelievable! This battle is reaching legendary status!");
		} elsif ($signal_3_count == 16) {
			quest::spawn2(1756, 0, 0, 1284.57, 1356.26, -97.17, 0);
			$npc->CameraEffect(2000, 3);
			quest::shout("Middleweight Title Bout!!!! - Ladies and Gentlemen, Introducing, Derakor the Vindicator!");
			$signal_3_count = 0;
		}
	}

	# Signal 4: Spawn King Tormax
	elsif ($signal == 4) {
		quest::spawn2(1755, 0, 0, 1294.06, 987.16, -94.36, 0);
		$npc->CameraEffect(2000, 3);
		quest::shout("First of 3 rounds for the Heavyweight Title!!!! - Bow before the might of King Tormax!");
	}

	# Signal 5: Start Round 2 Timer
	elsif ($signal == 5) {
		quest::shout("Round 2 coming up....The Avatar of War!!!!");
		quest::settimer("spawn_avatar", 20);
	}

	# Signal 6: Start Final Round Timer
	elsif ($signal == 6) {
		quest::shout("Final Round...Who dares enter the arena next?!");
		quest::settimer("spawn_final", 20);
	}

	# Signal 7: Announce the Winner (Once Per Player)
	elsif ($signal == 7) {
		my $has_announced = quest::get_data("signal_7_announced_$char_id");

		if (!$has_announced) {
			quest::we(14, "Ladies and Gentlemen");
			quest::settimer("champ_announcement_1", 2);
			quest::set_data("signal_7_announced_$char_id", 1);
		}
	}
}

sub EVENT_TIMER {
	if ($timer eq "spawn_avatar") {
		quest::stoptimer("spawn_avatar");
		$npc->CameraEffect(2000, 3);
		quest::spawn2(1754, 0, 0, 1294.06, 987.16, -94.36, 0);
	} elsif ($timer eq "spawn_final") {
		quest::stoptimer("spawn_final");
		$npc->CameraEffect(2000, 3);
		quest::shout("The final challenger has arrived... Prepare yourselves!");
		quest::spawn2(1758, 0, 0, 1294.06, 987.16, -94.36, 0);
	} elsif ($timer eq "champ_announcement_1") {
		quest::stoptimer("champ_announcement_1");
		quest::we(14, "The winner");
		quest::settimer("champ_announcement_2", 2);
	} elsif ($timer eq "champ_announcement_2") {
		quest::stoptimer("champ_announcement_2");
		quest::we(14, "And NEW... Heavyweight Champion of Kael!!!!!!");
	}
}

sub ListRematches {
	my $character_id = shift;

	my @messages = ();

	foreach my $npc_name (keys %rematches) {
		my $npc_id = $rematches{$npc_name}->{npc_id};
		if (quest::get_data("$character_id-rematch-$npc_id")) {
			my $rematch_link = quest::silent_saylink($npc_name);
			push(@messages, $rematch_link);
		}
	}

	if (defined $messages[0]) {
		my $message = join(" | ", @messages);
		quest::whisper("If you seek a rematch, select your opponent:");
		quest::message(315, $message);
	}
}