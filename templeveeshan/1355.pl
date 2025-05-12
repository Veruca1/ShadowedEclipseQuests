sub EVENT_SPAWN {
    quest::settimer("hunt", 1);  # Start the hunt timer immediately
}

sub EVENT_TIMER {
    if ($timer eq "hunt") {       
        my @clients = $entity_list->GetClientList();
        
        @clients = grep { !$_->GetGM() } @clients;
        
        if (@clients) {
            my $target = $clients[rand @clients];
            $target->Message(15, "You feel like you are being watched");
            $npc->MoveTo($target->GetX(), $target->GetY(), $target->GetZ(), $npc->GetHeading(), true); 
        }

        quest::settimer("hunt", 5);
    }
}

sub EVENT_DEATH_COMPLETE {  
    quest::stoptimer("hunt");
    quest::signalwith(1911, 500);
}
