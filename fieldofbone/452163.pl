sub EVENT_SAY {
    if ($text=~/hail/i) {
        # Offer the task/quest when hailed
        my $task_id = 12;  # Task ID 12
        $client->Message(14, "Greetings, adventurer. You need to earn access to this dungeon before you. Some strange force has brought me back from the dead and I do not wish to relive the great battle that took place here in the field long ago. Since my empire has long fallen, I will help adventurers clear this field of vermin that is not of the Iksar empire. This tower is now filled with creatures that do not belong here! Bring me back the pieces of the key to this tower.");
        quest::assigntask($task_id);  # Assign task ID 12
    }
}

sub EVENT_ITEM {
    # Define the item IDs required for Kurn's Tower access and the reward item
    my $item1 = 31684;
    my $item2 = 31683;
    my $reward_item = 31686;

    # Check if the player has handed in both required items
    if (plugin::check_handin(\%itemcount, $item1 => 1, $item2 => 1)) {
        # Give the reward item to the player
        $client->SummonItem($reward_item);
        
        # Notify the player about the reward and instructions
        $client->Message(15, "You now have the key to Kurn's Tower! Hand it in to Emperor Ganak.");
        
        # Optionally, you can give experience points
        quest::exp(1000);  # Give some experience points
    }
    # Check if the player hands in the reward item to gain access
    elsif (plugin::check_handin(\%itemcount, $reward_item => 1)) {
        # Grant access to Kurn's Tower by setting both the global flag and zone flag
        quest::set_zone_flag(97);   # Set zone flag for access

        # Notify the player about the access
        $client->Message(15, "You have been granted access to Kurn's Tower!");
        quest::we(14,"Help me congratulate $name! $name has been granted access to Kurn's Tower!");

        # Emperor Ganak provides the hint about the raid fight
        $client->Message(14, "It is rumored that there is one in Kunark who does not belong in our timeline. It is said that he has left items around to meddle with time and cause paradoxes. You must steer clear of those items, and certainly do not place them where they can alter the flow of time. Such actions could trigger dangerous, time-altering events.");
    }
    else {
        # Return items if the handin is not correct
        plugin::return_items(\%itemcount); 
    }
}
