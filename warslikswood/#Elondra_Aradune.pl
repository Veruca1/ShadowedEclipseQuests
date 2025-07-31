sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Offer the task/quest when hailed
        my $task_id = 14;  # Task ID for Dalnir access
        $client->Message(14, "Greetings, adventurer. The depths of Dalnir are not for the faint of heart. If you wish to gain access, you must prove yourself worthy. There are matters to tend to out in these woods. Once you have done that, I shall grant you access.");
        quest::assigntask($task_id);  # Assign task ID 14
    }
}

sub EVENT_ITEM {
    # Define the item IDs
    my $completion_item = 32459; # Item for Dalnir access
    my $letter_to_overthere = 32470; # Written letter to Overthere

    # Check if the player handed in the task completion item for Dalnir access
    if (plugin::check_handin(\%itemcount, $completion_item => 1)) {
        # Grant access to Dalnir by setting the zone flag
        quest::set_zone_flag(104);   # Set zone flag for Dalnir        
        quest::we(14, $name . " has earned access to The Crypt of Dalnir!");        
        $client->Message(15, "You now have access to The Crypt of Dalnir. Proceed with caution, adventurer.");
        
        # Optionally, provide experience points or additional rewards
        quest::exp(1000);
    }
    # Check if the player handed in the letter to Overthere
    elsif (plugin::check_handin(\%itemcount, $letter_to_overthere => 1)) {
        # Provide guidance to meet Neriah Dawnbinder and grant access to Overthere
        $client->Message(14, "I see you have found the letter. Time seems to have lost all meaning in that strange place. You should seek out Neriah Dawnbinder in The Overthere, outside the outpost. She can help guide you further.");
        
        # Grant access to The Overthere by setting the zone flag
        quest::set_zone_flag(93);   # Set zone flag for Overthere
    }
    else {
        # Return items if the hand-in is incorrect
        plugin::return_items(\%itemcount);
    }
}
