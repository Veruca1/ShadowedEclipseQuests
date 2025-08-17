sub EVENT_SPAWN {
    quest::settimer("hunt", 1);        # Start the hunt timer immediately
    quest::settimer("self_despawn", 180); # Depop after 3 minutes if not on the hunt
}

sub EVENT_TIMER {
    if ($timer eq "hunt") {
        my @clients = $entity_list->GetClientList();

        # Ignore GMs
        @clients = grep { !$_->GetGM() } @clients;

        if (@clients) {
            my $target = $clients[rand @clients];
            $target->Message(15, "You feel like you are being watched");
            $npc->MoveTo(
                $target->GetX(),
                $target->GetY(),
                $target->GetZ(),
                $npc->GetHeading(),
                true
            );

            # On first hunt, stop the despawn timer
            quest::stoptimer("self_despawn");
        }

        quest::settimer("hunt", 5);
    }
    elsif ($timer eq "self_despawn") {
        $npc->Depop();
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("hunt");
    quest::stoptimer("self_despawn");
}