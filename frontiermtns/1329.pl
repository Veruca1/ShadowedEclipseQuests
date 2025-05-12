sub EVENT_SAY {
    if ($text =~ /hail/i) {
        # Offer the task/quest when hailed
        my $task_id = 13;  # Task ID 13
        $client->Message(14, "Greetings, adventurer. Your efforts in the field of bone are appreciated. You will need to perform similar deeds here. A key is needed to gain access to the Temple of Droga. Once in, do what you can to learn about the place, and uncover its mysteries.");
        quest::assigntask($task_id);  # Assign task ID 13
    }
}

sub EVENT_ITEM {
    # Check if the player hands in items 32344, 32341, 32342, and 32343 to gain access to Temple of Droga
    if (plugin::check_handin(\%itemcount, 32344 => 1, 32341 => 1, 32342 => 1, 32343 => 1)) {
        # Grant access to Temple of Droga by setting both the global flag and zone flag
        quest::set_zone_flag(81);   # Set zone flag for access to Droga

        # Notify the player about the access
        $client->Message(14, "You have been granted access to The Temple of Droga!");

        $client->Message(14, "It is rumored that there is one in The Mountains who knows something about the ruined temple of worship to the south.");

        # Server-wide message with player's name
        quest::we(14,"Help me congratulate $name! $name has been granted access to The Temple of Droga!");  # Broadcast to all players in the zone
    }
    # Check if the player hands in item ID 32453 to gain access to Mines of Nurga
    elsif (plugin::check_handin(\%itemcount, 32453 => 1)) {
        # Grant access to Mines of Nurga by setting both the global flag and zone flag
        quest::set_zone_flag(107);  # Set zone flag for access to Nurga

        # Server-wide message with player's name
        quest::we(14,"Help me congratulate $name! $name has been granted access to The Mines of Nurga!");  # Broadcast to all players in the zone

        # Notify the player about the access
        $client->Message(14, "You have been granted access to The Mines of Nurga!");

        $client->Message(14, "Travel safely through the mines, adventurer. I will admit, not much is known about them.");
    }
    else {
        # Return items if the handin is not correct
        plugin::return_items(\%itemcount); 
    }
}
