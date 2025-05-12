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

            # Move towards the target using MoveTo
            $npc->MoveTo($target->GetX(), $target->GetY(), $target->GetZ(), $npc->GetHeading(), true);
            # The 'true' parameter ensures the NPC will run to the location
        }

        quest::settimer("hunt", 5);  # Adjust timer as needed
    }
    elsif ($timer eq "respawn") {
        quest::stoptimer("respawn");
        quest::spawn2(1435, 0, 0, $x, $y, $z, $h);  # Respawn at the original spawn location with NPC ID 1435
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("hunt");  # Stop hunt timer on death
    quest::settimer("respawn", 900);  # Respawn after 15 minutes
}
