my %reward_data = (
	984   => ["Leather", [4039, 4040, 4041, 4042, 4043, 4044, 4045]], # Raw Crude Hide
	34211 => ["Cloth", [4046, 4062, 4063, 4064, 4065, 4078, 4079]], # Coarse Silk
	34239 => ["Chain", [2829, 2830, 2854, 2855, 2856, 2857, 4038]], # Silvril Ore
	54229 => ["Plate", [1377, 1378, 1800, 1801, 1802, 2827, 2828]], # Chunk of Bronze
);

sub EVENT_SAY {
	if ($text=~/hail/i) {
		my $bring_link = quest::silent_saylink("Bring");
		my $recycle_link = quest::silent_saylink("recycle");
		my $chunk_link = quest::varlink(54229);
		my $silk_link = quest::varlink(34211);
		my $ore_link = quest::varlink(34239);
		my $hide_link = quest::varlink(984);
		quest::whisper("Greetings, traveler. I am a quartermaster of the *Shadowsbane*, guardians of the old ways. In ages past, our warriors, scouts, and mystics forged their own gear from the raw elements of Norrath.");
		quest::whisper("$bring_link me crafting materials, and I shall see them returned to you in the form of Shadowsbane armor:");
		quest::whisper("5 $chunk_link → a piece of mighty *Plate*");
		quest::whisper("5 $silk_link → soft yet magical *Cloth* garments");
		quest::whisper("5 $ore_link → agile and enduring *Chain* gear");
		quest::whisper("5 $hide_link → rugged *Leather* armor for scouts and wilds-born");
		quest::whisper("Each offering of five will yield one piece of our legacy. Choose wisely and wear it well.");
		quest::whisper("I can also help you [$recycle_link] Shadowsbane armor.");
	} elsif ($text=~/^bring$/i) {
		foreach my $item_id (sort {$a <=> $b} keys %reward_data) {
			my $item_count = quest::countitem($item_id);
			if ($item_count >= 5) {
				my $item_link = quest::varlink($item_id);
				my $total_items = int($item_count / 5);
				my $item_type = $reward_data{$item_id}[0];
				my $exchange_link = quest::silent_saylink($item_type, "exchange");
				quest::whisper("I can $exchange_link your $item_count $item_link for $total_items $item_type items.");
			}
		}
	} elsif ($text=~/recycle/i) {
		quest::whisper("If you bring me any Shadowsbane armor piece — up to four at once — I can break them down and return some of the raw materials used to forge them. You'll get *2 of the base material* for each armor item, even if they're mixed types.");
	} elsif ($text=~/^Chain$/i || $text=~/^Cloth$/i || $text=~/^Leather$/i || $text=~/^Plate$/i) {
		foreach my $item_id (sort {$a <=> $b} keys %reward_data) {
			my $item_type = $reward_data{$item_id}[0];
			if ($text eq $item_type) {
				my $item_count = quest::countitem($item_id);
				if ($item_count >= 5) {
					my @rewards = @{$reward_data{$item_id}[1]};
					while ($item_count >= 5) {
						quest::removeitem($item_id, 5);
						my $reward_id = quest::ChooseRandom(@rewards);
						my $reward_link = quest::varlink($reward_id);
						quest::whisper("You have received $reward_link for your assistance.");
						quest::summonitem($reward_id);
						$item_count -= 5;
					}
				}
			}
		}
	}
}


sub EVENT_ITEM {
	my %recycle_data = ();
	my %return_materials = ();
	my $recycled_any = 0;

	foreach my $item_id (sort {$a <=> $b} keys %reward_data) {
		my @rewards = @{$reward_data{$item_id}[1]};
		foreach my $reward_id (@rewards) {
			$recycle_data{$reward_id} = $item_id;
		}
	}

	foreach my $item_id (keys %itemcount) {
		next unless exists $recycle_data{$item_id};
		my $quantity = $itemcount{$item_id};

		for (1 .. $quantity) {
			if (plugin::takeItems($item_id => 1)) {
				$return_materials{$recycle_data{$item_id}} += 2;
				$recycled_any = 1;
			}
		}
	}

	if ($recycled_any) {
		quest::whisper("Reclaimed, reforged. May these materials serve you once again.");

		foreach my $mat_id (keys %return_materials) {
			quest::summonitem($mat_id, $return_materials{$mat_id});
		}

		return;
	}

	plugin::return_items(\%itemcount);
}