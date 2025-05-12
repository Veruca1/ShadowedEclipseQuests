sub EVENT_ITEM {
    # Check if the item with ID 9541 (a flickering crystal) is present
    if (plugin::check_handin(\%itemcount, 9541 => 1)) {
        
        # Send a message to the client
        $client->Message(15, "Hhhateee?...");

        # Start a timer to depop this NPC after a short delay (e.g., 5 seconds)
        quest::settimer("depop_insignificance", 5);
    }
    else {
        quest::debug("this is the else and item turn in failed");
        plugin::return_items(\%itemcount); # Return items if not the correct item
    }
}

sub EVENT_TIMER {
    if ($timer eq "depop_insignificance") {
        # Depop this NPC (a tiny insignificance) with a respawn delay
        quest::depop_withtimer();

        # Spawn the new NPC (glitch princess) at the specified location
        quest::spawn2(36117, 0, 0, 107.13, -456.48, -38.02, 454.50);

        # Stop the timer
        quest::stoptimer("depop_insignificance");
    }
}
