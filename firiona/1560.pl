sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Offer the task/quest when hailed
        my $task_id = 21;  # Task ID for Karnor's Castle access
        $client->Message(14, "Greetings, adventurer. Karnor's Castle is a place of danger and mystery. Before you can enter its gates, you must first prove your worth. There are challenges to overcome in the wilds. Return when you are ready, and I shall grant you access.");
        quest::assigntask($task_id);  # Assign task ID 21.
    }
}

sub EVENT_ITEM {
    # Define the item IDs
    my $key_to_karnors = 255;  # Key to Karnor's Castle

    # Check if the player handed in the key to Karnor's Castle
    if (plugin::check_handin(\%itemcount, $key_to_karnors => 1)) {
        # Grant access to Karnor's Castle by setting the zone flag
        quest::set_zone_flag(102);   # Set zone flag for Karnor's Castle

        # Announce to the whole zone that the player has been granted access to Karnor's Castle
        quest::we(14, $name . " has earned access to Karnor's Castle!");

        # Notify the player that they now have access
        $client->Message(15, "You now have access to Karnor's Castle. Tread carefully, adventurer. There are rumors of that place not being what is expected. It's like, it's gone back in time, yet not at the same time. Also, Venril Sathir is nowhere to be found there!");
        
        # Optionally, provide experience points or additional rewards
        quest::exp(1000);
    } else {
        # Return items if the hand-in is incorrect
        plugin::return_items(\%itemcount);
    }
}
