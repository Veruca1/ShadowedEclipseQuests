sub EVENT_SAY {
    my %class_options = (
        "Warrior" => 1, "Cleric" => 2, "Paladin" => 3, "Ranger" => 4,
        "Shadowknight" => 5, "Druid" => 6, "Monk" => 7, "Bard" => 8,
        "Rogue" => 9, "Shaman" => 10, "Necromancer" => 11, "Wizard" => 12,
        "Mage" => 13, "Enchanter" => 14, "Beastlord" => 15, "Berserker" => 16,
    );

    if ($text =~ /hail/i) {
        $client->Message(15, "Hello, $name. I can assist you with the following options:");
        $client->Message(15, "[" . quest::saylink("Change Class", 1, "Change Class") . "] - Change your class.");
        $client->Message(15, "[" . quest::saylink("Change Race", 1, "Change Race") . "] - Change your race.");
        $client->Message(15, "[" . quest::saylink("Unlearn AAs", 1, "Unlearn AAs") . "] - Unlearn your AAs and return all spent points.");
        if ($ulevel == 60) {
            $client->Message(15, "[" . quest::saylink("Refresh", 1, "Refresh Spells & Skills") . "] - Rescribe your spells and max your skills.");
        }
    }
    elsif ($text =~ /Unlearn AAs/i) {
        $client->Message(15, "Unlearning your AAs and refunding all points...");
        $client->ResetAA();
        $client->Message(15, "All your AAs have been reset and points refunded.");
    }
    elsif ($text =~ /Change Class/i) {
        $client->Message(15, "Which class would you like to become? Please choose from the following options:");
        foreach my $class_name (keys %class_options) {
            $client->Message(15, "[" . quest::saylink($class_name, 1, $class_name) . "] ");
        }
    }
    elsif (exists $class_options{$text}) {
        my $new_class = $class_options{$text};
        my $current_level = $client->GetLevel();

        $client->Message(15, "You have chosen to become a $text. Preparing to change your class...");

quest::untraindiscs();
$client->Message(15, "All your previous class disciplines have been removed.");
$client->SetBaseClass($new_class);
$client->Message(15, "Your class has been changed to $text.");
$client->MaxSkills();
$client->Message(15, "Your skills have been reset for the new class.");
$client->UnscribeSpellAll();
$client->Message(15, "All your previous spells have been unscribed.");
$client->ScribeSpells(1, $current_level);
$client->Message(15, "You have been scribed with your new class spells from level 1 to $current_level.");
quest::traindiscs(60, 1);
$client->Message(15, "All discipline tomes from level 1 to 60 have been trained.");
$client->Message(15, "You will now be disconnected briefly to finalize your class change. Please log back in.");
$client->WorldKick();

    }
    elsif ($text =~ /change race/i) {
        quest::whisper("Very well. Please choose from the following races:");
        ListRaces();
    }
    elsif ($text =~ /^r-(\d+)/i) {
        my $race_id = $1;
        my $race_name = quest::getracename($race_id);
        quest::whisper("Changing your race to $race_name.");
        quest::permarace($race_id);
    }
    elsif ($text =~ /Refresh/i && $ulevel == 60) {
        AutoTrain();
    }
    else {
        $client->Message(15, "I don't recognize that option. Please choose from the available commands.");
    }
}

sub ListRaces {
    my @race_messages;
    foreach my $race_id (1..12, 128, 130, 330, 522) {
        my $race_name = quest::getracename($race_id);
        my $race_link = quest::silent_saylink("r-$race_id", $race_name);
        push @race_messages, $race_link;
    }
    quest::whisper(join(" | ", @race_messages));
}

sub AutoTrain {
    $client->Message(15, "You have reached level $ulevel! Scribing spells and updating skills...");

    foreach my $skill (0 .. 42, 48 .. 54, 70 .. 74) {
        next unless $client->CanHaveSkill($skill);
        my $maxSkill = $client->MaxSkill($skill, $client->GetClass(), $ulevel);
        next unless $maxSkill > $client->GetRawSkill($skill);
        $client->SetSkill($skill, $maxSkill);
    }

    quest::scribespells(60, 1);

    if ($ulevel >= 50) {
        my @excluded_spells = (36930, 17791, 36927, 28784, 36849, 36931, 36939);
        foreach my $spell_id (@excluded_spells) {
            $client->UnscribeSpellBySpellID($spell_id);
        }
    }

    quest::traindiscs($ulevel, $ulevel - 1);
    $client->Message(15, "Your spells and skills have been refreshed!");
}
