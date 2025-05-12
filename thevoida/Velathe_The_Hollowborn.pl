sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::say("If you are ready to be reborn and have at least 400 AA points, I can offer you great power. Say [rebirth] to begin again or [view rebirth info] to see your current progress.");
    }
    elsif ($text=~/view rebirth info/i) {
        my $char_id = $client->CharacterID();
        my $class_id = $client->GetClass();
        my $rebirths_total = quest::get_data("$char_id-rebirth_total") || 0;
        my $rebirths_class = quest::get_data("$char_id-rebirth_class_$class_id") || 0;
        my $rebirth_value = quest::get_data("$char_id-rebirth_value") || 0;
        quest::say("Total Rebirths: $rebirths_total | Class ($class_id) Rebirths: $rebirths_class | Rebirth Value: $rebirth_value");
    }
    elsif ($text=~/rebirth/i) {
        my $rebirth_cost = 400;
        my $char_id = $client->CharacterID();
        my $class_id = $client->GetClass();
        my $name = $client->GetCleanName();

        if ($client->GetLevel() < 60) {
            $client->Message(13, "You must be at least level 60 to rebirth.");
            return;
        }

        if ($client->GetAAPoints() < $rebirth_cost) {
            $client->Message(13, "You need at least $rebirth_cost AA points to rebirth.");
            return;
        }

        $client->SetAAPoints($client->GetAAPoints() - $rebirth_cost);

        my $rebirths_total = quest::get_data("$char_id-rebirth_total") || 0;
        my $rebirths_class = quest::get_data("$char_id-rebirth_class_$class_id") || 0;
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
