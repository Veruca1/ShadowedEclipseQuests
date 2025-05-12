sub EVENT_SPAWN {
    quest::set_proximity_range(40, 40);
}

sub EVENT_ENTER {
    $client->Message(14, "You're REALLY gonna want to get this task before looting any drops in this zone, the pet is very strong and heals you if you are 40 percent or lower!");
}

sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::whisper("Greetings, adventurer. I have a special quest that might interest you. Are you " . quest::saylink("interested", 1) . "?");
        
        # Beastlord-specific message
        if ($class eq "Beastlord") {
            quest::whisper("Ah, I see you are a Beastlord! If you obtain the Charmander clickable gem, hand it back to me for a suitable upgrade.");
        }
        # Necromancer-specific message
        elsif ($class eq "Necromancer") {
            quest::whisper("Ah, I see you are a Necromancer! If you obtain the Charmander clickable gem, hand it back to me for a suitable upgrade.");
        }
        # Magician-specific message
        elsif ($class eq "Magician") {
            quest::whisper("Ah, I see you are a Magician! If you obtain the Charmander clickable gem, hand it back to me for a suitable upgrade.");
        }
    }
    elsif ($text=~/interested/i) {
        quest::whisper("Excellent! I have assigned you the quest. Good luck!");
        $client->AssignTask(7); # Replace '7' with the actual quest ID
    }
}

sub EVENT_SPAWN {
    quest::set_proximity_range(40, 40);
}

sub EVENT_ENTER {
    $client->Message(14, "You're REALLY gonna want to get this task before looting any drops in this zone, the pet is very strong and heals you if you are 40 percent or lower!");
}

sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::whisper("Greetings, adventurer. I have a special quest that might interest you. Are you " . quest::saylink("interested", 1) . "?");
        
        # Beastlord-specific message
        if ($class eq "Beastlord") {
            quest::whisper("Ah, I see you are a Beastlord! If you obtain the Charmander clickable gem, hand it back to me for a suitable upgrade.");
        }
        # Necromancer-specific message
        elsif ($class eq "Necromancer") {
            quest::whisper("Ah, I see you are a Necromancer! If you obtain the Charmander clickable gem, hand it back to me for a suitable upgrade.");
        }
        # Magician-specific message
        elsif ($class eq "Magician") {
            quest::whisper("Ah, I see you are a Magician! If you obtain the Charmander clickable gem, hand it back to me for a suitable upgrade.");
        }
    }
    elsif ($text=~/interested/i) {
        quest::whisper("Excellent! I have assigned you the quest. Good luck!");
        $client->AssignTask(7); # Replace '7' with the actual quest ID
    }
}

sub EVENT_ITEM {
    # Beastlord-specific item hand-in
    if ($class eq "Beastlord" && plugin::check_handin(\%itemcount, 29703 => 1)) {
        quest::say("Excellent! This gem will serve you well. Take this upgrade as a reward for your efforts.");
        quest::summonitem(481);  # The upgraded item for Beastlords
        quest::summonitem(29703); # Returns the item 29703
    }
    # Necromancer-specific item hand-in
    elsif ($class eq "Necromancer" && plugin::check_handin(\%itemcount, 29703 => 1)) {
        quest::say("Excellent! This gem will serve you well. Take this upgrade as a reward for your efforts.");
        quest::summonitem(485);  # The upgraded item for Necromancers
        quest::summonitem(29703); # Returns the item 29703
    }
    # Magician-specific item hand-in
    elsif ($class eq "Magician" && plugin::check_handin(\%itemcount, 29703 => 1)) {
        quest::say("Excellent! This gem will serve you well. Take this upgrade as a reward for your efforts.");
        quest::summonitem(492); # The upgraded item for Magicians
        quest::summonitem(29703); # Returns the item 29703
    }
    else {
        quest::say("I don't need this item, $name. Please bring me the correct item to complete the quest.");
        plugin::return_items(\%itemcount);
    }
}

