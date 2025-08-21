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
        $npc->Shout("YooHoo, up here.");
        quest::settimer("shout2", 5);
    }
    elsif ($timer eq "shout2") {
        quest::stoptimer("shout2");
        $npc->Shout("The final test, you did it!");
        quest::settimer("shout3", 5);
    }
    elsif ($timer eq "shout3") {
        quest::stoptimer("shout3");
        $npc->Shout("You still wont join me?");
        quest::settimer("shout4", 5);
    }
    elsif ($timer eq "shout4") {
        quest::stoptimer("shout4");

        # Send marquee message to all clients
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            $client->SendMarqueeMessage(15, 510, 1, 1, 5000, "Then you will die! See you amongst the false gods!");
        }

        # Depop all NPCs with ID 1595
        my @adds = $entity_list->GetNPCList();
        foreach my $npc (@adds) {
            if ($npc->GetNPCTypeID() == 1595) {
                $npc->Depop();
            }
        }

        quest::depop(); # Depop self
    }
}