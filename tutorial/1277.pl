sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::whisper("Greetings, adventurer. I have a special quest that might interest you. Are you " . quest::saylink("interested", 1) . "?");
        
        # Check if the player's class is Beastlord (class ID 15)
        if ($class eq "Beastlord") {
            quest::whisper("Ah, I see you are a Beastlord! If you obtain the Charmander clickable gem, hand it back to me for a suitable upgrade.");
        }
    }
    elsif ($text=~/interested/i) {
        quest::whisper("Excellent! I need you to complete this quest for me. If you succeed, you'll be rewarded with something useful for your battles.");
        quest::assigntask(7); # Replace '7' with the actual quest ID
    }
}

sub EVENT_ITEM {
    # Check for the standard quest item hand-in
    if (plugin::check_handin(\%itemcount, 1234 => 1)) {  # Replace '1234' with the actual item ID
        quest::summonitem(29702); # Container item ID as a reward
        quest::say("Congratulations on completing the quest! Here is your reward.");
        quest::faction(123, 10);  # Adjust faction as needed
        quest::exp(1000);  # Adjust experience as needed
    }
    # Check for the Beastlord-specific item hand-in
    elsif ($class eq "Beastlord" && plugin::check_handin(\%itemcount, 29703 => 1)) {
        quest::say("Excellent! This gem will serve you well. Take this upgrade as a reward for your efforts.");
        quest::summonitem(481); # The upgraded item
    }
    else {
        quest::say("I don't need this item, $name. Please bring me the correct item to complete the quest.");
        plugin::return_items(\%itemcount);
    }
}
