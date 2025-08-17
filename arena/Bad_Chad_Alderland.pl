sub EVENT_SPAWN {
	quest::delete_data("wave_event");
}

sub EVENT_SAY {
	my $wave_event = quest::get_data("wave_event");

	if ($text =~ /hail/i) {
		quest::whisper("Welcome to the Arena! I am Bad Chad Alderland, your announcer for today's grand event. I have been sent here by The Eternal Covenant to find the best of the best to help combat The Shadowed Eclipse and eventually strike them up in the Plane of Hate itself? Do you have what it takes? You can choose between a [" . quest::saylink("5-wave encounter") . "] or a [" . quest::saylink("10-wave encounter") . "]. It should go without saying of course that there is risk vs reward. So, which will it be?");
	} elsif ($text =~ /5-wave encounter/i) {
		if (defined $wave_event && $wave_event ne "") {
			quest::whisper("An event is already in progress. Please wait until the current event ends.");
		} else {
			quest::whisper("You've chosen the 5-wave encounter. Prepare yourself! The event will begin shortly. Good luck! Rewards include:");
			quest::message(315, " - Up to 5 alternate currency coins");
			quest::message(315, " - A chance at an illusion item");
			quest::message(315, " - A very rare chance at an item from the merchant shop");
			quest::set_data("wave_event", "5");
			quest::settimer("wave1", 10);
		}
	} elsif ($text =~ /10-wave encounter/i) {
		if (defined $wave_event && $wave_event ne "") {
			quest::whisper("An event is already in progress. Please wait until the current event ends.");
		} else {
			quest::whisper("You've chosen the 10-wave encounter. Brace yourself for a tougher challenge! The event will begin shortly. Best of luck! Rewards include:");
			quest::message(315, " - Between 5 and 10 alternate currency coins");
			quest::message(315, " - An increased chance at an illusion item");
			quest::message(315, " - Better odds at receiving gear from the merchant shop");
			quest::set_data("wave_event", "10");
			quest::settimer("wave1", 10);
		}
	}
}

sub EVENT_TIMER {
	if ($timer eq "wave1") {
		quest::stoptimer("wave1");
		quest::shout("The first wave is about to begin!");
		quest::spawn2(1227, 0, 0, 5.24, 391.55, -5.52, 261);
	} elsif ($timer eq "wave2") {
		quest::stoptimer("wave2");
		quest::shout("It is time. Wave 2...Begin!");
		quest::spawn2(1228, 0, 0, 88.10, 36.13, -5.50, 293);
	} elsif ($timer eq "wave3") {
		quest::stoptimer("wave3");
		quest::shout("It is time. Wave 3...Begin!");
		quest::spawn2(1229, 0, 0, 243.27, 303.45, -5.50, 335.75);
	} elsif ($timer eq "wave4") {
		quest::stoptimer("wave4");
		quest::shout("It is time. Wave 4...Begin!");
		quest::spawn2(1230, 0, 0, -362.55, -53.82, -4.05, 423);
		quest::spawn2(1231, 0, 0, -183.37, 370.49, -4.00, 213.25);
	} elsif ($timer eq "wave5") {
		quest::stoptimer("wave5");
		quest::shout("It is time. Wave 5...Begin!");
		quest::spawn2(1232, 0, 0, -4.22, -480.98, -6.39, 1.25);
		quest::spawn2(502004, 0, 0, -4.22, -480.98, -6.39, 1.25);
	} elsif ($timer eq "wave6") {
		quest::stoptimer("wave6");
		quest::shout("It is time. Wave 6...Begin!");
		quest::spawn2(1240, 0, 0, -151.12, 48.17, -5.81, 119.25);
		quest::spawn2(1241, 0, 0, -142.63, 79.00, -5.81, 129.25);
	} elsif ($timer eq "wave7") {
		quest::stoptimer("wave7");
		quest::shout("It is time. Wave 7...Begin!");
		quest::spawn2(1242, 0, 0, 185.66, 194.15, -5.50, 340.75);
		quest::spawn2(1244, 0, 0, 191.99, 183.59, -5.50, 340.75);
	} elsif ($timer eq "wave8") {
		quest::stoptimer("wave8");
		quest::shout("It is time. Wave 8...Begin!");
		quest::spawn2(1243, 0, 0, 6.44, 330.91, -6.44, 2.16);
	} elsif ($timer eq "wave9") {
		quest::stoptimer("wave9");
		quest::shout("It is time. Wave 9...Begin!");
		quest::spawn2(1247, 0, 0, -2.94, -233.98, 4.21, 6.00);
	} elsif ($timer eq "wave10") {
		quest::stoptimer("wave10");
		quest::shout("It is time. Wave 10...Begin!");
		quest::spawn2(1251, 0, 0, -2.94, -233.98, 4.21, 6.00);
	}
}

sub EVENT_SIGNAL {
	my $wave_event = quest::get_data("wave_event");

	if ($signal == 1) {
		quest::shout("Fantastic! Rest up. Your next opponent is in 1 second!");
		quest::settimer("wave2", 1);
	} elsif ($signal == 2) {
		quest::shout("Fantastic! Rest up. Your next opponent is in 1 second!");
		quest::settimer("wave3", 1);
	} elsif ($signal == 3) {
		quest::shout("Fantastic! Rest up. Your next opponent is in 1 second!");
		quest::settimer("wave4", 1);
	} elsif ($signal == 4) {
		quest::shout("Fantastic! Rest up. Your next opponent is in 1 second!");
		quest::settimer("wave5", 1);
	} elsif ($signal == 5) {
		if ($wave_event eq "5") {
			quest::shout("Congratulations, you have beaten the 5-wave event, here is your reward. Now go show The Eclipse what we are made of!");
			quest::spawn2(77028, 0, 0, 3.33, 53.83, 6.75, 511.25);
			quest::delete_data("wave_event");
		} elsif ($wave_event eq "10") {
			quest::shout("Fantastic! Rest up. Your next opponent is in 1 second!");
			quest::settimer("wave6", 1);
		}
	} elsif ($signal == 6) {
		quest::shout("Fantastic! Rest up. Your next opponent is in 1 second!");
		quest::settimer("wave7", 1);
	} elsif ($signal == 7) {
		quest::shout("Fantastic! Rest up. Your next opponent is in 1 second!");
		quest::settimer("wave8", 1);
	} elsif ($signal == 8) {
		quest::shout("Fantastic! Rest up. Your next opponent is in 1 second!");
		quest::settimer("wave9", 1);
	} elsif ($signal == 9) {
		quest::shout("Fantastic! Rest up. Your final opponent is in 1 second!!");
		quest::settimer("wave10", 1);
	} elsif ($signal == 10) {
		quest::shout("Congratulations, you have beaten the 10-wave event, here is your reward. Now go show The Eclipse what we are made of!");
		quest::spawn2(77029, 0, 0, 3.33, 53.83, 6.75, 511.25);
		quest::delete_data("wave_event");
	}
}