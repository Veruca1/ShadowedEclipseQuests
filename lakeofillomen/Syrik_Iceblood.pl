sub EVENT_ITEM {
    # Check if the player hands in the correct item (Item ID 33033)
    if (plugin::check_handin(\%itemcount, 33033 => 1)) {
        # Set zone flag for Veksar (Zone ID 109)
        quest::set_zone_flag(109); 
        
        # Announce to the entire zone that the player has earned access to Veksar
        quest::we(14, "$name has earned access to Veksar!"); 
        
        # Assign quest (task) ID 20 to the player
        quest::assigntask(20);
        
        # Notify the player that they now have access to Veksar
        $client->Message(15, "You now have access to Veksar. Be very careful and avoid ending up like the other lost souls there.");
    }
    else {
        # Return items if they are not the correct ones
        quest::say("I have no need for these items, $name.");
        plugin::return_items(\%itemcount);
        
        # Ensure script exits correctly after returning items
        return;
    }
}

sub EVENT_SAY {
    # Handle player greeting or dialogue initiation
    if ($text=~/hail/i) {
        quest::say("Greetings, $name. If you seek access to Veksar, you must first prove your worth.");

        # Assign task ID 19 to the player
        quest::assigntask(19);
    }
}
