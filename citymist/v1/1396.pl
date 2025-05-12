sub EVENT_SPAWN {
    # Set a timer to depop the NPC after 120 seconds (1.5 minutes)
    quest::settimer("depop_timer", 120);
}

sub EVENT_TIMER {
    if ($timer eq "depop_timer") {
        quest::depop();  # Despawn the NPC after the timer expires
    }
}

sub EVENT_ITEM {
    # Check if the player handed in the correct items: 1 of each (1681, 33028, 33029)
    if (plugin::check_handin(\%itemcount, 1681 => 1, 33028 => 1, 33029 => 1)) {
        
        $client->Message(14, "I wish my parents weren't such fools! Thank you for killing High Scale Kirn! With this second chance at life, I will restore the city of Torsis to its former glory!");

        # Reward the player with Item ID 33030
        quest::summonitem(33030);
        
        quest::depop();  # Despawn Zal after delivering the message
    }
    else {
        # If the hand-in is incorrect, return the items
        plugin::return_items(\%itemcount);
        $client->Message(14, "I cannot accept these items.");
    }
}

sub EVENT_DEATH {
    # Optionally add any death-related functionality here
}
