sub EVENT_SPAWN {
    quest::settimer("check_buffs", 1);

    # Start a sequence for shouts
    quest::settimer("shout1", 5);
}

sub EVENT_TIMER {
    if ($timer eq "check_buffs") {
        quest::stoptimer("check_buffs");
        $npc->CastSpell(12879, $npc->GetID()) if !$npc->FindBuff(12879);
    }

    # Shout sequence handling
    elsif ($timer eq "shout1") {
        quest::stoptimer("shout1");
        $npc->Shout("HahAHAHahaha! Wonderful!.");
        quest::settimer("shout2", 10);
    }
    elsif ($timer eq "shout2") {
        quest::stoptimer("shout2");
        $npc->Shout("My new Arm, you replaced a whole army!.");
        quest::settimer("shout3", 10);
    }
    elsif ($timer eq "shout3") {
        quest::stoptimer("shout3");
        $npc->Shout("I have one final test for you.");
        quest::settimer("shout4", 10);
    }
    elsif ($timer eq "shout4") {
        quest::stoptimer("shout4");

        # Send marquee message to all clients
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "SEE YOU SOON, IN THE STARS!");
        }

        # Start the timer for the signal
        quest::settimer("signal", 5);
    }
    elsif ($timer eq "signal") {
        quest::stoptimer("signal");

        # Signal the specified NPC
        quest::signalwith(10, 40, 0);
    }
}
