sub EVENT_SAY {
	if ($text=~/hail/i) {
		my $choose_link = quest::silent_saylink("choose");
		my $hear_link = quest::silent_saylink("hear");
		quest::emote("glances up as you approach.");
		quest::whisper("Greetings, traveler, and welcome to Shadowed Eclipse. I am Sir Bard McQuaiden, here to guide you through your adventures. Our server is a place of exploration and discovery, where quests and tasks take a backseat to the thrill of the unknown. While much of Norrath may seem familiar, our custom content is designed to challenge even the most seasoned adventurers. Would you like to $hear_link a tale of our world? Or would you like to $choose_link your starter?");
	}  elsif ($text=~/^hear$/i) {
		my $title = "The Shadowed Eclipse";
		my $message = "
		In the depths of Norrath, a sinister presence stirs, weaving its malevolent influence through the fabric of time itself.<br><br>
		Deep within the shadows, <c \"#FF0000\">Chronomancer Zarrin</c>, a being of ancient power and dark ambition, plots his nefarious designs. Obsessed with rewriting the course of history, Zarrin seeks to undo the very foundations of Norrath's creation, plunging the world into chaos and darkness.<br><br>
		From his shadowed lair, he commands legions of undead and demons. His influence spreads, corrupting the land and ensnaring the hearts of mortals.<br><br>
		Across haunted mines and towering peaks, signs of his presence grow more ominous. At the heart of his empire stands <c \"#FF0000\">Abyssal Dreadlord Xyron</c>, twisted and cruel, enforcing Zarrin’s will with ruthless efficiency.<br><br>
		As heroes rise to challenge the darkness, they must face these enemies and uncover the full extent of Zarrin’s plan.<br><br>
		The fate of Norrath hangs in the balance.";
		quest::popup($title, $message);
	}  elsif ($text=~/choose/i) {
		if (check_player_has_pet()) {
			quest::whisper("You already possess a companion. You cannot choose another.");
			return;
		}

		my $title = "Starter Pokémon Descriptions";
		my $desc = "<c \"#FF0000\">Charmander</c><br>
		Cauterizing Heal - Heal group for 500 HP, only triggers under 50% HP<br>
		Charmander's Fire Shield - Applies Damage Shield to All Party Members. Stacks with most Damage Shields<br><br>
		<c \"#00FF00\">Bulbasaur</c><br>
		Bulbasaur's Regeneration - Heal 50 HP per Tick<br>
		Bulbasaur's Thorn Root - Root Effect with DOT. 150 DD, 50 DMG DOT<br><br>
		<c \"#00FFFF\">Squirtle</c><br>
		Squirtle's Turtle Shell - HP/AC Buff that stacks with other HP/AC buffs<br>
		Squirtle's Turtle Roar - AE Taunt<br><br>
		<c \"#FFFF00\">Pikachu</c><br>
		Pikachu's Thunderbolt - 150 DD and 1 second stun every 3 seconds<br>
		Pikachu's Thunder - Buffs all Party Members with a 65 DD proc on melee hits (Think Divine Might).";
		quest::popup($title, $desc);

		quest::whisper("Choose wisely—this decision is final.");

		my %starter_names = (
			971    => "Bulbasaur",
			972    => "Squirtle",
			973    => "Pikachu",
			29703  => "Charmander"
		);

		my @pet_messages = ();
		foreach my $item_id (sort {$starter_names{$a} cmp $starter_names{$b}} keys %starter_names) {
			unless (check_player_has_pet($item_id)) {
				my $name = $starter_names{$item_id};
				my $pet_link = quest::silent_saylink($name);
				push(@pet_messages, $pet_link);
			}
		}

		my $pet_message = join(" | ", @pet_messages);
		quest::message(315, $pet_message);
	}  elsif ($text=~/^(Bulbasaur|Squirtle|Pikachu|Charmander)$/i) {
		my %name_to_item = (
			Bulbasaur  => 971,
			Squirtle   => 972,
			Pikachu    => 973,
			Charmander => 29703
		);

		my $requested_name = ucfirst(lc($1));
		my $item_id = $name_to_item{$requested_name};

		if (check_player_has_pet()) {
			quest::whisper("You already possess a pet companion. You cannot choose another one.");
			return;
		}

		if (check_player_has_pet($item_id)) {
			quest::whisper("You already possess this companion.");
		} else {
			$client->SummonItem($item_id);
			$client->UpdateTaskActivity(34, 1, 1);
			quest::whisper("Your companion has been granted.");
		}
	}
}

sub check_player_has_pet {
	my ($pet_id) = @_;

	if ($pet_id) {
		return check_item_in_inventory_or_bank($pet_id);
	}

	my @possible_pets = (971, 972, 973, 29703);
	foreach my $item_id (@possible_pets) {
		return 1 if check_item_in_inventory_or_bank($item_id);
	}

	return 0;
}

sub check_item_in_inventory_or_bank {
	my ($item_id) = @_;

	foreach my $slot (get_inventory_slots()) {
		my $item = $client->GetItemIDAt($slot);
		return 1 if $item == $item_id;
	}

	foreach my $slot (get_bank_slots()) {
		my $item = $client->GetItemIDAt($slot);
		return 1 if $item == $item_id;
	}

	return 0;
}

sub get_inventory_slots {
	return (
		quest::getinventoryslotid("possessions.begin") .. quest::getinventoryslotid("possessions.end"),
		quest::getinventoryslotid("generalbags.begin") .. quest::getinventoryslotid("generalbags.end"),
		quest::getinventoryslotid("bank.begin") .. quest::getinventoryslotid("bank.end"),
		quest::getinventoryslotid("bankbags.begin") .. quest::getinventoryslotid("bankbags.end"),
		quest::getinventoryslotid("sharedbank.begin") .. quest::getinventoryslotid("sharedbank.end"),
		quest::getinventoryslotid("sharedbankbags.begin") .. quest::getinventoryslotid("sharedbankbags.end"),
	);
}

sub get_bank_slots {
	return (
		quest::getinventoryslotid("bank.begin") .. quest::getinventoryslotid("bank.end"),
		quest::getinventoryslotid("bankbags.begin") .. quest::getinventoryslotid("bankbags.end"),
		quest::getinventoryslotid("sharedbank.begin") .. quest::getinventoryslotid("sharedbank.end"),
		quest::getinventoryslotid("sharedbankbags.begin") .. quest::getinventoryslotid("sharedbankbags.end"),
	);
}

sub EVENT_ITEM {
	if (plugin::check_handin(\%itemcount, 636 => 1)) {
		$client->SetTitleSuffix("Newbie No More", 1);  # <-- Set suffix title
		$client->NotifyNewTitlesAvailable();           # <-- Force client to see it right away
		quest::whisper("You have earned the title 'Newbie No More'!");
		quest::we(13, "$name has defeated the tutorial, and earned the title Newbie No More!");
		quest::discordsend("titles", "$name has earned the title of Newbie No More!");
	}

	plugin::return_items(\%itemcount);
}

sub EVENT_SPAWN {
	$npc->ApplySpellBuff(13378, 60);
}