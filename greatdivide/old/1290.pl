my %class_options = (
    "Warrior"       => 1,
    "Cleric"        => 2,
    "Paladin"       => 3,
    "Ranger"        => 4,
    "Shadow Knight" => 5,
    "Druid"         => 6,
    "Monk"          => 7,
    "Bard"          => 8,
    "Rogue"         => 9,
    "Shaman"        => 10,
    "Necromancer"   => 11,
    "Wizard"        => 12,
    "Magician"      => 13,
    "Enchanter"     => 14,
    "Beastlord"     => 15,
    "Berserker"     => 16,
);

sub EVENT_SAY {
    if ($text =~ /hail/i) {
        $client->Message(15, "Hello, $name. I can help you with the following options:");
        $client->Message(15, "[" . quest::saylink("Unscribe Spells", 1, "Unscribe Spells") . "] - Remove all your currently scribed spells.");
        $client->Message(15, "[" . quest::saylink("Change Class", 1, "Change Class") . "] - Change your class to another one.");
    }
    elsif ($text =~ /Unscribe Spells/i) {
        # Unscribe all spells
        $client->UnscribeSpellAll();
        $client->Message(15, "All your spells have been unscribed.");
    }
    elsif ($text =~ /Change Class/i) {
        $client->Message(15, "Which class would you like to become? Please choose from the following options:");

        # List all available classes as clickable links
        foreach my $class_name (keys %class_options) {
            $client->Message(15, "[" . quest::saylink($class_name, 1, $class_name) . "]");
        }
    }
    elsif (exists $class_options{$text}) {
        my $new_class = $class_options{$text};
        my $current_level = $client->GetLevel();

        $client->Message(15, "You have chosen to become a $text. Preparing to change your class...");

        # Delevel the player by 1 to apply the class change
        if ($current_level > 1) {
            $client->SetLevel($current_level - 1);
            $client->Message(15, "Your level has been temporarily reduced to " . ($current_level - 1) . ".");
        }

        # Change the player's class
        $client->SetBaseClass($new_class);
        $client->Message(15, "Your class has been changed to $text.");

        # Relevel the player back to the original level
        $client->SetLevel($current_level);
        $client->Message(15, "You have been restored to level $current_level.");

        # Unscribe all previous class spells
        $client->UnscribeSpellAll();
        $client->Message(15, "All your previous spells have been unscribed.");

        # Re-scribe spells for the new class from level 1 to the current level
        $client->ScribeSpells(1, $current_level);  # Adjust to start at level 1 to current level
        $client->Message(15, "You have been scribed with your new class spells from level 1 to $current_level.");

        # Kick player to character select to finalize the class change
        $client->Message(15, "You will now be disconnected briefly to finalize your class change. Please log back in.");
        $client->WorldKick();
    }
    else {
        $client->Message(15, "I don't recognize that option. Please choose from the available commands.");
    }
}

sub EVENT_ITEM {
    plugin::returnUnusedItems(); # Return any items handed to the NPC
}
