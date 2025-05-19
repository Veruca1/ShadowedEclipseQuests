sub EVENT_SAY {
    my %class_names = (
        1 => "Warrior",
        2 => "Cleric",
        3 => "Paladin",
        4 => "Ranger",
        5 => "Shadow Knight",
        6 => "Druid",
        7 => "Monk",
        8 => "Bard",
        9 => "Rogue",
        10 => "Shaman",
        11 => "Necromancer",
        12 => "Wizard",
        13 => "Magician",
        14 => "Enchanter",
        15 => "Beastlord",
        16 => "Berserker"
    );

    my $name = $client->GetCleanName();
    if (lc($name) ne "croaknight") {
        quest::say("The void stirs, but I am not yet ready to guide you. I will make an announcement when I am ready.");
        return;
    }

    if ($text=~/hail/i) {
        quest::say("The cycle of souls turns ever onward. If your spirit is strong and you possess the wisdom of many lifetimes (1000 AA per rebirth level), I can guide you through rebirth. Speak the word [rebirth] to begin anew, or ask to [view rebirth info] to reflect on your journey thus far.");
    }
    elsif ($text=~/view rebirth info/i) {
        my $char_id = $client->CharacterID();
        my $class_id = $client->GetClass();
        my $class_name = $class_names{$class_id} || "Unknown";
        my $rebirths_total = quest::get_data("$char_id-rebirth_total") || 0;
        my $rebirths_class = quest::get_data("$char_id-rebirth_class_$class_id") || 0;
        my $rebirth_value = quest::get_data("$char_id-rebirth_value") || 0;
        quest::say("Total Rebirths: $rebirths_total | Class ($class_name) Rebirths: $rebirths_class | Rebirth Value: $rebirth_value");
    }
    elsif ($text=~/rebirth/i) {
        my $char_id = $client->CharacterID();
        my $class_id = $client->GetClass();
        my $name = $client->GetCleanName();

        my $rebirths_total = quest::get_data("$char_id-rebirth_total") || 0;
        my $rebirths_class = quest::get_data("$char_id-rebirth_class_$class_id") || 0;

        # Check if player has reached the rebirth cap for their class
        if ($rebirths_class >= 10) {
            $client->Message(13, "You have reached the current limit of your power for the $class_names{$class_id} class. To progress anew, you must walk a different path and choose another class.");
            return;
        }

        my $next_rebirth_level = $rebirths_total + 1;
        my $rebirth_cost = 1000 * $next_rebirth_level;

        if ($client->GetLevel() < 60) {
            $client->Message(13, "You must be at least level 60 to rebirth.");
            return;
        }

        if ($client->GetAAPoints() < $rebirth_cost) {
            $client->Message(13, "You need at least $rebirth_cost AA points to rebirth (1000 AA per rebirth level).");
            return;
        }

        $client->SetAAPoints($client->GetAAPoints() - $rebirth_cost);

        my $rebirth_value = quest::get_data("$char_id-rebirth_value") || 0;

        $rebirths_total++;
        $rebirths_class++;
        $rebirth_value++;

        quest::set_data("$char_id-rebirth_total", $rebirths_total);
        quest::set_data("$char_id-rebirth_class_$class_id", $rebirths_class);
        quest::set_data("$char_id-rebirth_value", $rebirth_value);

        my @bot_list = $entity_list->GetBotListByCharacterID($char_id);
        foreach my $bot (@bot_list) {
            if ($bot->GetPetID() > 0) {
                my $bot_pet = $entity_list->GetNPCByID($bot->GetPetID());
                $bot_pet->Depop() if $bot_pet;
            }
            $bot->Depop();
        }
        my $pet = $client->GetPet();
        $pet->Depop() if $pet;

        my @buffs_to_keep = (36959, 40605);
        remove_unwanted_buffs($client, @buffs_to_keep);

        $client->SetLevel(1);
        $client->SetEXP(0, 0);

        if ($rebirths_total == 1) {
            $client->GrantAlternateAdvancementAbility(18000, 1);
            $client->Message(15, "Rebirth Reward: Experienced Rebirther granted - you gain a 25%% experience bonus.");
        }
        elsif ($rebirths_total == 2) {
            $client->GrantAlternateAdvancementAbility(18001, 1);
            $client->Message(15, "Rebirth Reward: Gelid Nimbus unlocked - your attacks may now unleash frost damage.");
        }
        elsif ($rebirths_total == 3) {
            $client->GrantAlternateAdvancementAbility(18002, 1);
            $client->Message(15, "Rebirth Reward: Pyro Nimbus unlocked - your damage shield power increases.");
        }
        elsif ($rebirths_total == 4) {
            $client->GrantAlternateAdvancementAbility(18003, 1);
            $client->Message(15, "Rebirth Reward: Hardened Veteran unlocked - your attacks now deal 20% more damage.");
        }
        elsif ($rebirths_total == 5) {
            $client->GrantAlternateAdvancementAbility(18004, 1);
            $client->Message(15, "Rebirth Reward: Brutal Efficiency unlocked - your critical strikes have a 10% chance to deal 500% damage.");
        }
        elsif ($rebirths_total == 6) {
            $client->GrantAlternateAdvancementAbility(18005, 1);
            $client->Message(15, "Rebirth Reward: Unyielding Will granted - you gain passive damage mitigation.");
        }
        elsif ($rebirths_total == 7) {
            $client->GrantAlternateAdvancementAbility(18006, 1);
            $client->Message(15, "Rebirth Reward: Echoing Onslaught unlocked - your attacks may now strike multiple enemies.");
        }
        elsif ($rebirths_total == 8) {
            $client->GrantAlternateAdvancementAbility(18007, 1);
            $client->Message(15, "Rebirth Reward: Enduring Spirit unlocked - you gain +10,000 HP, +10,000 Mana, and +5,000 Endurance.");
        }
        elsif ($rebirths_total == 9) {
            $client->GrantAlternateAdvancementAbility(18008, 1);
            $client->Message(15, "Rebirth Reward: Perfect Execution unlocked - unleash a flawless strike that scales with your rebirths.");
        }
        elsif ($rebirths_total == 10) {
            $client->GrantAlternateAdvancementAbility(18009, 1);
            $client->Message(15, "Rebirth Reward: Adaptive Predation unlocked - your strikes may now restore health through combat intuition.");
        }

        quest::say("You have been reborn. Your journey begins anew.");
    }
}


sub remove_unwanted_buffs {
    my ($client, @buffs_to_keep) = @_;
    my @buffs = $client->GetBuffSpellIDs();
    foreach my $spell_id (@buffs) {
        next if grep { $_ == $spell_id } @buffs_to_keep;
        $client->BuffFadeBySpellID($spell_id);
    }
}
