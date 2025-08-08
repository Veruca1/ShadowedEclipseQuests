my @locs = (
	[-132.40, 217.20, 218.10, 384.00],  
	[-175.67, 217.03, 220.01, 126.50],  
	[-132.45, 244.79, 220.01, 383.50],  
	[-176.53, 244.90, 220.01, 126.00],  
	[-176.42, 273.08, 220.01, 126.25],  
	[-132.65, 273.01, 220.01, 384.50],  
	[-131.88, 301.20, 220.01, 382.25],  
	[-176.00, 301.00, 219.98, 128.00],  
	[-78.00, 286.00, 218.73, 511.00],  
	[-92.00, 288.00, 218.73, 511.00],  
	[-100.00, 298.00, 218.73, 511.00],  
	[-35.50, 372.60, 218.10, 464.00],  
	[-56.59, 477.44, 244.23, 213.50],  
	[-43.55, 543.82, 218.23, 335.50],  
	[-62.14, 549.88, 218.23, 244.50],  
	[-90.40, 601.00, 220.10, 382.00],  
	[-90.40, 615.60, 220.10, 382.00],  
	[-252.00, 429.00, 244.73, 511.00],  
	[-256.13, 440.75, 244.73, 202.00],  
	[-217.00, 296.00, 218.73, 478.00],  
	[-217.00, 282.00, 218.73, 511.00],  
	[-89.28, 414.08, 218.13, 377.50],  
	[-114.00, 472.00, 218.73, 317.00],  
	[-204.00, 463.00, 218.73, 183.00],  
	[-158.00, 435.00, 219.98, 511.00],  
	[-149.00, 435.00, 218.73, 511.00],  
	[-137.00, 430.00, 218.73, 511.00],  
	[-137.00, 420.00, 218.73, 511.00],  
	[-137.00, 412.00, 218.73, 511.00],  
	[-137.00, 403.00, 218.73, 511.00],  
	[-171.00, 430.00, 218.73, 511.00],  
	[-171.00, 420.00, 218.73, 511.00],  
	[-171.00, 412.00, 218.73, 511.00],  
	[-171.00, 403.00, 218.73, 511.00]
);

sub EVENT_SAY {
	my $char_id = $client->CharacterID();
	my $flag = "$char_id-dobby_says_flag";

	if ($text =~ /hail/i) {
		if (quest::get_data($flag)) {
			my $ready_link = quest::silent_saylink("ready");
			quest::whisper("Dobby sees you have freed him! Are you ready to play Dobby Says? Just tell me when you're $ready_link to begin!");
		} else {
			quest::whisper("Dobby is still bound! A sock, Dobby needs a sock to be free!");
		}
	} elsif ($text =~ /ready/i) {
		if (quest::get_data($flag)) {
			quest::whisper("Dobby says… be prepared! The game will start soon!");
			start_acolyte_event();
		} else {
			quest::whisper("Dobby cannot play until you free him with a sock!");
		}
	}
}

sub EVENT_ITEM {
	my $char_id = $client->CharacterID();  # Get the player's character ID
	my $flag_700 = "$char_id-700_handin";  # Databucket for item 700 hand-in
	my $flag = "$char_id-dobby_says_flag";  # Flag for item 675 hand-in

	if (plugin::check_handin(\%itemcount, 675 => 1)) {  # Sock Item ID: 675
		my $ready_link = quest::silent_saylink("ready");
		quest::set_data($flag, 1);
		quest::whisper("Master has given Dobby a sock! Dobby is FREE! Oh, happiest of days! But wait—Master must play Dobby Says! Yes, yes! Just tell me when you're $ready_link to begin!");
	}
	# Check if the player has already handed in item 700
	elsif (plugin::check_handin(\%itemcount, 700 => 1)) {  # Felix Fortuna of the Arcane Draft
		if (quest::get_data($flag_700)) {
			quest::say("You have already handed in the Felix Fortuna of the Arcane Draft and cannot do so again.");
			plugin::return_items(\%itemcount);  # Return the item if already handed in
		} else {
			quest::say("Oh! Clever wizard brings shiny draft to Dobby! So powerful, so mysterious! Dobby is most pleased! Here, take this, yes, yes! It will help, oh yes!");
			quest::summonitem(687);  # Give the player item 687
			quest::set_data($flag_700, 1);  # Set the flag to prevent future hand-ins of item 700
		}
	}

	plugin::return_items(\%itemcount);  # Return the item if not recognized
}

sub start_acolyte_event {
	my $num_acolytes = int(rand(6)) + 5;  # 5 to 10 acolytes

	quest::set_data("acolytes_needed", $num_acolytes);
	quest::set_data("acolytes_killed", 0);  # Reset kill count

	# Fisher-Yates Shuffle Algorithm
	for (my $i = $#locs; $i > 0; $i--) {
		my $j = int(rand($i + 1));
		(@locs[$i, $j]) = (@locs[$j, $i]);  # Swap elements
	}

	for (my $i = 0; $i < $num_acolytes; $i++) {
		my ($x, $y, $z, $h) = @{$locs[$i]};
		quest::spawn2(1777, 0, 0, $x, $y, $z, $h);
	}

	quest::whisper("Dobby has summoned $num_acolytes Death Eater Acolytes. Dobby says, Defeat them all!");
}

sub start_inferi_event {
	my $num_inferi = int(rand(6)) + 5;  # 5 to 10 Inferi

	quest::set_data("inferi_needed", $num_inferi);
	quest::set_data("inferi_killed", 0);  # Reset kill count

	# Fisher-Yates Shuffle Algorithm
	for (my $i = $#locs; $i > 0; $i--) {
		my $j = int(rand($i + 1));
		(@locs[$i, $j]) = (@locs[$j, $i]);  # Swap elements
	}

	for (my $i = 0; $i < $num_inferi; $i++) {
		my ($x, $y, $z, $h) = @{$locs[$i]};
		quest::spawn2(1783, 0, 0, $x, $y, $z, $h);
	}

	quest::whisper("Dobby has summoned $num_inferi Undead Inferi. Dobby says, Defeat them all!");
}

sub start_fiendfyre_event {
	my $num_fiendfyre = int(rand(6)) + 5;  # 5 to 10 Fiendfyre

	quest::set_data("fiendfyre_needed", $num_fiendfyre);
	quest::set_data("fiendfyre_killed", 0);  # Reset kill count

	# Fisher-Yates Shuffle Algorithm
	for (my $i = $#locs; $i > 0; $i--) {
		my $j = int(rand($i + 1));
		(@locs[$i, $j]) = (@locs[$j, $i]);  # Swap elements
	}

	for (my $i = 0; $i < $num_fiendfyre; $i++) {
		my ($x, $y, $z, $h) = @{$locs[$i]};
		quest::spawn2(1784, 0, 0, $x, $y, $z, $h);
	}

	quest::whisper("Dobby has summoned $num_fiendfyre cursed Fiendfyre. Dobby says, Defeat them all!");
}

sub start_corrupted_event {
	my $num_corrupted = int(rand(6)) + 5;  # 5 to 10 Corrupted

	quest::set_data("corrupted_needed", $num_corrupted);
	quest::set_data("corrupted_killed", 0);  # Reset kill count

	# Fisher-Yates Shuffle Algorithm
	for (my $i = $#locs; $i > 0; $i--) {
		my $j = int(rand($i + 1));
		(@locs[$i, $j]) = (@locs[$j, $i]);  # Swap elements
	}

	for (my $i = 0; $i < $num_corrupted; $i++) {
		my ($x, $y, $z, $h) = @{$locs[$i]};
		quest::spawn2(1785, 0, 0, $x, $y, $z, $h);
	}

	quest::whisper("Dobby has summoned $num_corrupted Corrupted Souls. Dobby says, Defeat them all!");
}

sub EVENT_SIGNAL {
	if ($signal == 1) {  # Death Eater Acolytes killed
		my $acolytes_killed = quest::get_data("acolytes_killed") // 0;
		$acolytes_killed++;
		quest::set_data("acolytes_killed", $acolytes_killed);

		if ($acolytes_killed >= quest::get_data("acolytes_needed")) {
			quest::spawn2(1778, 0, 0, -154.00, 452.00, 222.98, 250.00) unless quest::isnpcspawned(1778);
		}
	} elsif ($signal == 4) {
		start_inferi_event();
	} elsif ($signal == 2) {  # Inferi killed
		my $inferi_killed = quest::get_data("inferi_killed") // 0;
		$inferi_killed++;
		quest::set_data("inferi_killed", $inferi_killed);

		if ($inferi_killed >= quest::get_data("inferi_needed")) {
			quest::spawn2(1779, 0, 0, -154.00, 452.00, 222.98, 250.00) unless quest::isnpcspawned(1779);
		}
	} elsif ($signal == 5) { # Start Fiendfyre event
		start_fiendfyre_event();
	} elsif ($signal == 6) {  # Fiendfyre killed
		my $fiendfyre_killed = quest::get_data("fiendfyre_killed") // 0;
		$fiendfyre_killed++;
		quest::set_data("fiendfyre_killed", $fiendfyre_killed);

		if ($fiendfyre_killed >= quest::get_data("fiendfyre_needed")) {
			quest::spawn2(1780, 0, 0, -154.00, 452.00, 222.98, 250.00) unless quest::isnpcspawned(1780);
		}
	} elsif ($signal == 7) { # Start Corrupted event
		start_corrupted_event();
	} elsif ($signal == 8) {  # Corrupted killed
		my $corrupted_killed = quest::get_data("corrupted_killed") // 0;
		$corrupted_killed++;
		quest::set_data("corrupted_killed", $corrupted_killed);

		if ($corrupted_killed >= quest::get_data("corrupted_needed")) {
			quest::spawn2(1781, 0, 0, -154.00, 452.00, 222.98, 250.00) unless quest::isnpcspawned(1781);
		}
	} elsif ($signal == 3) {  # Mrs. Norris Spawn Chance
		if (rand() < 0.25) {  # 25% chance
			my ($x, $y, $z, $h) = (quest::get_data("mrs_norris_x"), quest::get_data("mrs_norris_y"), quest::get_data("mrs_norris_z"), quest::get_data("mrs_norris_h"));
			quest::spawn2(1782, 0, 0, $x, $y, $z, $h) if $x && $y && $z && $h && !quest::isnpcspawned(1782);
		}
	} elsif ($signal == 9) {  # Spawn Bellatrix Lestrange
		quest::spawn2(1786, 0, 0, -154.00, 452.00, 222.98, 250.00) unless quest::isnpcspawned(1786);
	}
}
