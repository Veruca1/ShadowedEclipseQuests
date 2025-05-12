sub EVENT_SPAWN {
    quest::settimer("hunt", 1);  # Start the hunt timer immediately
}

sub EVENT_TIMER {
    if ($timer eq "hunt") {
        my @clients = $entity_list->GetClientList();
        
        # Filter out GM clients
        @clients = grep { !$_->GetGM() } @clients;  
                
        if (@clients) {
            my $target = $clients[rand @clients];
            $target->Message(15, "You feel like you are being watched");

            # Move towards the target
            quest::moveto($target->GetX(), $target->GetY(), $target->GetZ());
            
            # Ensure the NPC aggroes the player
            $npc->AddToHateList($target, 10000);
        }
        
        quest::settimer("hunt", 5);  # Repeat the hunt every 5 seconds
    }
}

sub EVENT_DEATH_COMPLETE {  
    quest::stoptimer("hunt");  # Stop hunt timer on death
}
