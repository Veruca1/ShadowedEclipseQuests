sub EVENT_SPAWN {
    quest::set_proximity_range(40, 40);
}

sub EVENT_ENTER {
    $client->Message(14, "You're REALLY gonna want to get this task before venturing off in Kunark, the pet is very strong and is an upgrade to Charizard!");
}

sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::whisper("Greetings, adventurer. I have a special quest that might interest you. Are you " . quest::saylink("interested", 1) . "?");
        
        # Beastlord-specific message
        if ($class eq "Beastlord") {
            quest::whisper("Ah, I see you are a Beastlord! If you obtain the Charizard X clickable gem, hand it back to me for a suitable upgrade.");
        }
        # Necromancer-specific message
        elsif ($class eq "Necromancer") {
            quest::whisper("Ah, I see you are a Necromancer! If you obtain the Charizard X clickable gem, hand it back to me for a suitable upgrade.");
        }
        # Magician-specific message
        elsif ($class eq "Magician") {
            quest::whisper("Ah, I see you are a Magician! If you obtain the Charizard X clickable gem, hand it back to me for a suitable upgrade.");
        }
    }
    elsif ($text=~/interested/i) {
        quest::whisper("Excellent! I have assigned you the quest. Good luck!");
        $client->AssignTask(25); # Updated task ID
    }
}

sub EVENT_ITEM {
    # Beastlord-specific item hand-in
    if ($class eq "Beastlord" && plugin::check_handin(\%itemcount, 341 => 1)) {
        quest::say("Excellent! This gem will serve you well. Take this upgrade as a reward for your efforts.");
        quest::summonitem(484);  # Updated reward for Beastlords
        quest::summonitem(341);  # Return the original gem
    }
    # Necromancer-specific item hand-in
    elsif ($class eq "Necromancer" && plugin::check_handin(\%itemcount, 341 => 1)) {
        quest::say("Excellent! This gem will serve you well. Take this upgrade as a reward for your efforts.");
        quest::summonitem(488);  # Updated reward for Necromancers
        quest::summonitem(341);  # Return the original gem
    }
    # Magician-specific item hand-in
    elsif ($class eq "Magician" && plugin::check_handin(\%itemcount, 341 => 1)) {
        quest::say("Excellent! This gem will serve you well. Take this upgrade as a reward for your efforts.");
        quest::summonitem(495);  # Same reward for Magicians
        quest::summonitem(341);  # Return the original gem
    }
    else {
        quest::say("I don't need this item, $name. Please bring me the correct item to complete the quest.");
        plugin::return_items(\%itemcount);
    }
}
