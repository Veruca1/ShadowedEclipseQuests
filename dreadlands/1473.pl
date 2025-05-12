sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::say("Greetings, adventurer! The other Flux could not handle any more work, simpleton. Anyway, anything from Sebilis, hand it in here.");
    }
}

sub EVENT_ITEM {
    # Melee torso hand-in items
    if (plugin::check_handin(\%itemcount, 147793 => 1, 294 => 1)) { # #BRD
        quest::summonitem(314);
        quest::say("Here is your reward for your hard work, brave Bard!");
    }
    elsif (plugin::check_handin(\%itemcount, 147790 => 1, 294 => 1)) { # #SHD
        quest::summonitem(315);
        quest::say("Here is your reward for your hard work, fearless Shadow Knight!");
    }
    elsif (plugin::check_handin(\%itemcount, 147742 => 1, 294 => 1)) { # #PAL
        quest::summonitem(317);
        quest::say("Here is your reward for your hard work, noble Paladin!");
    }
    elsif (plugin::check_handin(\%itemcount, 147721 => 1, 294 => 1)) { # #WAR
        quest::summonitem(318);
        quest::say("Here is your reward for your hard work, valiant Warrior!");
    }
    elsif (plugin::check_handin(\%itemcount, 148042 => 1, 295 => 1)) { # #BST
        quest::summonitem(323);
        quest::say("Here is your reward for your hard work, resourceful Beastlord!");
    }
    elsif (plugin::check_handin(\%itemcount, 148000 => 1, 294 => 1)) { # #MNK
        quest::summonitem(325);
        quest::say("Here is your reward for your hard work, skilled Monk!");
    }
    elsif (plugin::check_handin(\%itemcount, 147979 => 1, 294 => 1)) { # #RNG
        quest::summonitem(326);
        quest::say("Here is your reward for your hard work, sharp-eyed Ranger!");
    }
    elsif (plugin::check_handin(\%itemcount, 147958 => 1, 294 => 1)) { # #BER
        quest::summonitem(327);
        quest::say("Here is your reward for your hard work, fearsome Berserker!");
    }
    elsif (plugin::check_handin(\%itemcount, 147937 => 1, 294 => 1)) { # #ROG
        quest::summonitem(328);
        quest::say("Here is your reward for your hard work, cunning Rogue!");
    }

    # Caster torso hand-in items
    elsif (plugin::check_handin(\%itemcount, 147895 => 1, 295 => 1)) { # #ENC
        quest::summonitem(319);
        quest::say("Here is your reward for your hard work, wise Enchanter!");
    }
    elsif (plugin::check_handin(\%itemcount, 147874 => 1, 295 => 1)) { # #NEC
        quest::summonitem(320);
        quest::say("Here is your reward for your hard work, dark Necromancer!");
    }
    elsif (plugin::check_handin(\%itemcount, 147853 => 1, 295 => 1)) { # #WIZ
        quest::summonitem(321);
        quest::say("Here is your reward for your hard work, powerful Wizard!");
    }
    elsif (plugin::check_handin(\%itemcount, 147832 => 1, 295 => 1)) { # #MAG
        quest::summonitem(322);
        quest::say("Here is your reward for your hard work, knowledgeable Magician!");
    }
    elsif (plugin::check_handin(\%itemcount, 148021 => 1, 295 => 1)) { # #DRU
        quest::summonitem(324);
        quest::say("Here is your reward for your hard work, devoted Druid!");
    }
    elsif (plugin::check_handin(\%itemcount, 147916 => 1, 295 => 1)) { # #SHM
        quest::summonitem(329);
        quest::say("Here is your reward for your hard work, insightful Shaman!");
    }
    elsif (plugin::check_handin(\%itemcount, 147769 => 1, 295 => 1)) { # #CLR
        quest::summonitem(316);
        quest::say("Here is your reward for your hard work, righteous Cleric!");
    }

    # New item hand-in for items 398 and 341 to get item 397
    elsif (plugin::check_handin(\%itemcount, 398 => 1, 341 => 1)) {
        quest::summonitem(397);
        quest::say("Here is your reward for your dedication, $name!");
    }
    else {
        quest::say("I have no need for this item, $name.");
        plugin::return_items(\%itemcount);
    }
}
