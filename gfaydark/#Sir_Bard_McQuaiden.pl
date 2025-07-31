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
	my %class_options = (
		"Warrior" => 1, "Cleric" => 2, "Paladin" => 3, "Ranger" => 4,
		"Shadowknight" => 5, "Druid" => 6, "Monk" => 7, "Bard" => 8,
		"Rogue" => 9, "Shaman" => 10, "Necromancer" => 11, "Wizard" => 12,
		"Mage" => 13, "Enchanter" => 14, "Beastlord" => 15, "Berserker" => 16,
	);

	if ($text =~ /hail/i) {
		my $aa_link = quest::silent_saylink("Refund AAs");
		my $class_link = quest::silent_saylink("Change Class");
		my $race_link = quest::silent_saylink("Change Race");
		quest::whisper("Hello, $name. I can assist you with the following options:");
		quest::message(315, "[$aa_link] - Change your class.");
		quest::message(315, "[$class_link] - Change your race.");
		quest::message(315, "[$race_link] - Unlearn your AAs and return all spent points.");
	} elsif ($text =~ /Refund AAs/i) {
		quest::whisper("Unlearning your AAs and refunding all points...");
		$client->ResetAA();
		quest::whisper("All your AAs have been reset and points refunded.");
	} elsif ($text =~ /Change Class/i) {
		quest::whisper("Which class would you like to become? Please choose from the following options:");
		ListClassOptions();
	} elsif (exists $class_options{$text}) {
		my $new_class = $class_options{$text};
		my $current_level = $client->GetLevel();

		quest::whisper("You have chosen to become a $text. Preparing to change your class...");

		quest::untraindiscs();
		quest::whisper("All your previous class disciplines have been removed.");
		$client->SetBaseClass($new_class);
		quest::whisper("Your class has been changed to $text.");
		$client->MaxSkills();
		quest::whisper("Your skills have been reset for the new class.");
		$client->UnscribeSpellAll();
		quest::whisper("All your previous spells have been unscribed.");
		$client->ScribeSpells(1, $current_level);
		quest::whisper("You have been scribed with your new class spells from level 1 to $current_level.");
		quest::traindiscs(60, 1);
		quest::whisper("All discipline tomes from level 1 to 60 have been trained.");
		quest::whisper("You will now be disconnected briefly to finalize your class change. Please log back in.");
		$client->WorldKick();
	} elsif ($text =~ /change race/i) {
		quest::whisper("Very well. Please choose from the following races:");
		ListRaces();
	} elsif ($text =~ /^r-(\d+)/i) {
		my $race_id = $1;
		my $race_name = quest::getracename($race_id);
		quest::whisper("Changing your race to $race_name.");
		quest::permarace($race_id);
	} else {
		quest::whisper("I don't recognize that option. Please choose from the available commands.");
	}
}

sub ListRaces {
	my @race_messages = ();
	foreach my $race_id (1..12, 128, 130, 330, 522) {
		my $race_name = quest::getracename($race_id);
		my $race_link = quest::silent_saylink("r-$race_id", $race_name);
		push @race_messages, $race_link;
	}

	my $race_message = join(" | ", @race_messages);
	quest::message(315, $race_message);
}

sub ListClassOptions {
	my @class_messages = ();

	foreach my $class_id (1..16) {
		my $class_name = quest::getclassname($class_id);
		my $class_link = quest::silent_saylink($class_name);
		push @class_messages, $class_link;
	}

	my $class_message = join(" | ", @class_messages);
	quest::message(315, $class_message);
}