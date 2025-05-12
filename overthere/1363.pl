sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Offer the task/quest when hailed
        my $task_id = 15;  # Task ID for Howling Stones access
        $client->Message(14, "Greetings, adventurer. If you wish to brave the haunted halls of Howling Stones, you must prove yourself worthy. The Chronomancer has really messed with time here. We need to undo some of his meddling. Once you have taken care of this list, come back to me.");
        quest::assigntask($task_id);  # Assign task ID 15
    }
}

sub EVENT_ITEM {
    # Define the item IDs
    my $howling_stones_item = 32460;  # Item required for Howling Stones access
    my $love_letter_item = 32471;     # Love Letter from Drusella to Venril
    
    # Check if the player handed in the task completion item for Howling Stones access
    if (plugin::check_handin(\%itemcount, $howling_stones_item => 1)) {
        # Grant access to Howling Stones by setting the zone flag
        quest::set_zone_flag(105);   # Set zone flag for Howling Stones

        # Announce to the whole zone that the player has been granted access to Howling Stones
        quest::we(14, $name . " has earned access to Howling Stones!");

        # Notify the player that they now have access
        $client->Message(14, "You now have access to Howling Stones. Tread carefully, for it is filled with great danger.");
        
        # Assign quest/task 16 to the player
        quest::assigntask(16);  # Assign task ID 16
        
        # Optionally, provide experience points or additional rewards
        quest::exp(1000);
        
        # Return the item 32460 since it is needed for Charasis access
        quest::summonitem($howling_stones_item);
    }
    # Check if the player hands in the Love Letter from Drusella to Venril
elsif (plugin::check_handin(\%itemcount, $love_letter_item => 1)) {
    # Grant the player the Tomb Raider title (suffix)
    $client->SetTitleSuffix("Tomb Raider", 1);  # Correct: grant suffix title
    $client->NotifyNewTitlesAvailable();        # Refresh available titles list
    $client->Message(14, "What a significant find! This letter reveals secrets long buried. For such a discovery, you shall be known as 'Tomb Raider'.");
    quest::we(13, "$name has uncovered ancient secrets and earned the title Tomb Raider!");
    quest::discordsend("titles", "$name has earned the title of Tomb Raider!");        
    # Summon item 33177 as an additional reward
    quest::summonitem(33177);  # Summon item with ID 33177

    }
    else {
        # Return items if the hand-in is incorrect
        plugin::return_items(\%itemcount);
    }
}
