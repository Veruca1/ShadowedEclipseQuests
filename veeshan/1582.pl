sub EVENT_ITEM {
    # Define the item ID and the NPC to spawn
    my $trigger_item = 433;
    my $spawn_npc = 1585;

    # Check if the player hands in the trigger item
    if (plugin::check_handin(\%itemcount, $trigger_item => 1)) {
        # Send a message to the player
        $client->Message(15, "YOU BETTER GET BACK!!!...");

        # Start a 10-second timer
        quest::settimer("spawn_npc", 10);
    }
    else {
        # Return items if the handin is not correct
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_TIMER {
    if ($timer eq "spawn_npc") {
        # Stop the timer to prevent repetition
        quest::stoptimer("spawn_npc");

        # Get the NPC's current location
        my $x = $npc->GetX();
        my $y = $npc->GetY();
        my $z = $npc->GetZ();
        my $h = $npc->GetHeading();

        # Spawn the NPC at the same location
        quest::spawn2(1585, 0, 0, $x, $y, $z, $h);
    }
}
