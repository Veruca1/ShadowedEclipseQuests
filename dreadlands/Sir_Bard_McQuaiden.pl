sub EVENT_ITEM {
	my $reward_item = 31711;
	my $special_item = 32456;
	my $ej_access_item = 33177; # New item for Emerald Jungle access
	my $veksar_item = 33103;    # New item for Veksar event
	my $zebuxoruk_item = 256;   # Item for Zebuxoruk and Kotiz
	my $handwritten_letter = 384; # Handwritten letter from Firiona
	my $burning_woods_item = 33300; # Item for Burning Woods access
	my $essence_of_icicles = 517;  # Item for Iceclad Ocean access
	my $item_666 = 666;           # Crony Killer item

	# Check if the player hands in item 384 (handwritten letter)
	if (plugin::check_handin(\%itemcount, $handwritten_letter => 1)) {
		quest::whisper("Well, first of all Savior, we cannot thank you enough for besting the Chronomancer. However, as we feared, the ripple effects of his tampering are still out there. We have heard rumors of something strange happening in the Burning Woods. Please go beyond the veil of smoke and investigate.");
		quest::set_zone_flag(87);  # Set zone flag for Burning Woods
		quest::we(14, $name . " has earned access to the Burning Woods!");  # Announce access to the player
	}
	# Check if the player hands in item 256
	elsif (plugin::check_handin(\%itemcount, $zebuxoruk_item => 1)) {
		quest::whisper("Astonishing! The great book of Zebuxoruk and Kotiz. All signs point to Sebilis. Please rendezvous with Firiona Vie in Trakanon's Teeth for further instruction.");
		quest::set_zone_flag(95);  # Set zone flag for the relevant zone
		quest::summonitem(262);    # Grant the player the Key to Sebilis
	}
	# Check if the player hands in the reward item to gain access
	elsif (plugin::check_handin(\%itemcount, $reward_item => 1)) {
		# Grant access to The Frontier Mountains by setting both the global flag and zone flag
		quest::set_zone_flag(92);   # Set zone flag for access
		
		# Notify the player about the access
		quest::whisper("This is a fascinating find, adventurer! Proof of Zarrin's meddling with time indeed. You are to proceed to the Frontier Mountains and meet up with our envoy there. You have been granted access to The Frontier Mountains!");
	}
	# Check if the player hands in item 32456
	elsif (plugin::check_handin(\%itemcount, $special_item => 1)) {
		# Notify the player and set the zone flag for Warsliks Woods
		quest::whisper("This is a fantastic find! It shows Zarrin's further interference with time. We are to report to Elondra in Warsliks Woods immediately.");
		quest::set_zone_flag(79);   # Set zone flag for Warsliks Woods
	}
	# Check if the player hands in the item 33177 for Emerald Jungle
	elsif (plugin::check_handin(\%itemcount, $ej_access_item => 1)) {
		# Grant access to the Emerald Jungle
		quest::set_zone_flag(94);   # Set zone flag for Emerald Jungle
		
		# Notify the player with the new message
		quest::whisper("Amazing! You got to witness evil incarnate with the likes of Drusella and Venril alive at the same time? How are you still here? Rest up, you are needed again in the Emerald Jungle. Rendezvous with Hairen there. There have been reports of ancient Yclist citizens roaming about. Until now, we thought they were just a myth.");
	}
	# Check if the player hands in the item 33103 for Veksar event
	elsif (plugin::check_handin(\%itemcount, $veksar_item => 1)) {
		# Notify the player and set the zone flag for Veksar
		quest::whisper("Absolutely astonishing! I had heard about the disruption in Veksar but had my doubts we could win this one. Very well. We are near the end of this journey. Meet up with Saren Battlebrow in Firiona Vie with haste!");
		quest::set_zone_flag(84);   # Set zone flag for Veksar
	}
	# Check if the player hands in the new item 33300 for Burning Woods
	elsif (plugin::check_handin(\%itemcount, $burning_woods_item => 1)) {
		# Notify the player and set the zone flag for Burning Woods
		quest::whisper("The Burning Woods hold many secrets. Your journey is not over yet, brave adventurer. Keep pushing forward!");
		quest::set_zone_flag(87);   # Set zone flag for Burning Woods
	}
	elsif (plugin::check_handin(\%itemcount, $essence_of_icicles => 1)) {
		quest::set_zone_flag(110);
		
		$client->SetTitleSuffix("Savior of Kunark", 1);
		$client->NotifyNewTitlesAvailable();
		$client->Message(15, "You have earned the title 'Savior of Kunark'!");        
		quest::we(14, "$name has earned access to Iceclad Ocean in Velious!");
		quest::we(13, "$name has earned the title Savior of Kunark!");
		quest::discordsend("titles", "$name has earned the title of Savior of Kunark!");

		# Whisper to the player with lore and instructions
		quest::whisper("So, you have bested all that VP had to unleash on you and rid us of The Chronomancer once and for all! That is beyond words great news. However, you uncovered a new adversary, Nyseria, the Veilkeeper. I have heard whispers of a Coven within the Shadowed Eclipse. Where Zarrin was all about forcing everyone to his will, Nyseria is all about manipulating everyone to gladly join her cause. It seems she has eyes on you. Speak with Hollen, and head over to Iceclad at once. Meet up with Masurt at the Docks. Until you are able to gain some ground there in Velious, you will have to come back here or Gfay to recoup.");
	}
   # Check if the player hands in item 666 (Crony Killer item)
	elsif (plugin::check_handin(\%itemcount, $item_666 => 1)) {
		$client->SetTitleSuffix("Crony Killer", 1);
		$client->NotifyNewTitlesAvailable();
		quest::whisper("Congratulations, $name! You have earned the title 'Crony Killer' for your incredible achievements!");
		quest::we(13, "$name has earned the title Crony Killer!");
		quest::discordsend("titles", "$name has earned the title of Crony Killer!");
	}

	plugin::return_items(\%itemcount);
}

sub EVENT_SAY {
	if ($text=~/hail/i) {
		quest::popup("The Next Challenge Awaits", "
		<c '#FFCC00'>*The NPC regards you with a measured gaze, acknowledging the long journey you’ve taken to arrive here.*</c><br><br>

		\"So, you’ve made it to <c '#FF6600'>Kunark</c>. This ancient land holds many dangers, but none more pressing than the shadow that looms over the <c '#FF6600'>Field of Bone and beyond</c>—the barren wasteland you now need to go to.<br><br>

		While the defeat of Abyssal Dreadlord Xyron in the Plane of Hate was a victory worth celebrating, it was only a single battle in a much larger war. Chronomancer Zarrin’s dark influence is even stronger here, twisting time and unearthing powers that should have remained buried.<br><br>

		<c '#FFCC00'>*The NPC glances toward the horizon, thinking about the decayed ruins of an ancient tower.*</c><br><br>

		There is a tower you see, <c '#FF6600'>Kurn’s Tower</c>, that is more than just a ruin. It’s the key to unraveling the mysteries of this land... and one of the sources of Zarrin’s growing strength. But the tower is sealed, locked behind wards that can only be broken by relics scattered across the cursed field of bone.<br><br>

		The undead that roam there guard the relics fiercely. They are remnants of a forgotten empire, and their hatred for the living still burns strong. To gain access to Kurn’s Tower, you must gather these pieces and forge the key. Only then can you step inside and face the horrors within.<br><br>

		But know this—Kurn’s Tower is no ordinary place. Time is fractured there, and strange, terrible things await those who enter unprepared. Zarrin’s influence grows stronger the closer you get to the dreaded peaks of Veeshan.<br><br>

		<c '#FFCC00'>*The NPC fixes you with a hard stare, their tone grave.*</c><br><br>

		You’ve come far, but Kunark will push you to your limits. Gather your strength and your courage, adventurer. The trials ahead are unlike anything you've faced before. Zarrin meddles with time and even alternate realities.\"");
	}
}
