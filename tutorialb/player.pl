use POSIX;	# Add this at the top of your quest file
sub EVENT_ENTERZONE {
	quest::MovePCInstance(189, $instanceid, 2, -146, 19.6, 303.75); # Zone: tutorialb
	
	if (
		!$client->IsTaskActive(3) &&
		!$client->IsTaskActive(34) &&
		!$client->IsTaskCompleted(3) &&
		!$client->IsTaskCompleted(34)
	) {
		quest::popup("Join the revolution!",
				 "Welcome to the Fight Against The Shadowed Eclipse! You have been given two new quests:
					 <br><br><c \"#FFFF00\">Explore The Tutorial Revamp:</c><br>This will guide you to the custom parts of this zone, PAY CLOSE ATTENTION to ITEM LORE.<br><br><c \"#FFFF00\">Welcome to the Shadowed Eclipse:</c><br>Do this to obtain the reward, it will have a clicky to West Commons to get you to the next dungeon, BE SURE to get the tutorial clicky off Captains first so you can come back..<br><br><c \"#F07F00\">Click 'OK' to continue.</c>");
		quest::assigntask($_) for (3, 34);
	}
}

sub EVENT_TASK_COMPLETE {
	if ($task_id == 3) {
		$client->UpdateTaskActivity(34, 2, 1);
	} elsif ($task_id == 35) { # Task 35 completion: grant scaled EXP
		my $level = $client->GetLevel();
		my $current_exp = $client->GetEXP();
		my $next_level_exp = $client->GetEXPForLevel($level + 1);
		my $level_exp = $next_level_exp - $client->GetEXPForLevel($level);

		#quest::debug("Player Level: $level");
		#quest::debug("Current EXP: $current_exp");
		#quest::debug("Next Level EXP: $next_level_exp");
		#quest::debug("EXP Needed for Level: $level_exp");

		my $exp_reward = 0;

		if ($level <= 5) {
			$exp_reward = $level_exp;	# Full level
		} elsif ($level <= 10) {
			$exp_reward = int($level_exp * 0.5);	# Half level
		} elsif ($level <= 20) {
			$exp_reward = int($level_exp * 0.25);	# Quarter level
		}

		my $multiplier = 1 / 0.65;	# Reverse the Character:ExpMultiplier
		$exp_reward = ceil($exp_reward * $multiplier);	# Always round up

		#quest::debug("Calculated EXP Reward (Adjusted): $exp_reward");

		if ($exp_reward > 0) {
			$client->AddEXP($exp_reward);
			my $new_exp = $client->GetEXP();
			my $exp_gained = $new_exp - $current_exp;

			#quest::debug("Post-award EXP: $new_exp");
			#quest::debug("Actual EXP gained: $exp_gained");

			$client->Message(15, "You feel yourself grow stronger from completing the task!");
			#quest::debug("Task 35 complete: Level $level - granted $exp_reward EXP (adjusted).");
		} else {
			$client->Message(13, "You're too powerful to gain experience from this task.");
			#quest::debug("No EXP awarded due to level: $level");
		}
	} elsif ($task_id == 36) { # Task 36 completion: remove scavenger relics
		foreach my $item_id (976, 977, 978, 979, 980) {
			$client->RemoveItem($item_id);
		}
		$client->Message(15, "The ancient relics dissolve as their essence flows into the newly awakened ring.");
		#quest::debug("Removed all scavenger relic items after task 36 completed.");
	}
}

sub EVENT_PLAYER_PICKUP {
	my %scavenger_items = (
		976 => 0,	# Rotting Goblin Idol
		977 => 1,	# Kobold Clan Heirloom
		978 => 2,	# Web Stained Map
		979 => 3,	# Decayed Stone Fragment
		980 => 4,	# Slavemaster Ruga's Barbed Whip
	);

	my %next_hints = (
		0 => "They say the kobolds kept something precious hidden in their cells, kept safe behind the bed.",
		1 => "One escapee dropped something as he fled the spider caverns. Search near silk and shadows.",
		2 => "The Overlord hides the Stone of Prophecy in the safest location.",
		3 => "The Cruelest Tool, used by the Foulest Master, is said to be kept near its owner at all times.",
		4 => "You've found them all, and with a shimmer of magic, the ring absorbs the other relics becoming whole again.",
	);

	my $task_id = 36;

	if (exists $scavenger_items{$picked_up_id}) {
		my $activity_id = $scavenger_items{$picked_up_id};

		# Only update if the activity is still active
		if (!$client->IsTaskActivityActive($task_id, $activity_id)) {
			return;
		}

		quest::updatetaskactivity($task_id, $activity_id, 1);
		#quest::debug("Scavenger Hunt: Picked up item $picked_up_id → Activity $activity_id");

		my $hint = $next_hints{$activity_id} || "Keep searching...";
		$client->Message(15, "You feel one step closer to understanding... $hint");
	}
}