sub EVENT_SPAWN {
    quest::settimer("explode_timer", 20);
}

sub EVENT_TIMER {
    if ($timer eq "explode_timer") {
        quest::stoptimer("explode_timer");

        $npc->Emote("explodes in a violent surge of magic!") if $npc;

        # Damage all players
        my @client_list = $entity_list->GetClientList();
        foreach my $client (@client_list) {
            next unless $client;
            $client->Damage($npc, 7500, 0, 1, 0);

            my $pet = $client->GetPet();
            $pet->Damage($npc, 7500, 0, 1, 0) if $pet;
        }

        # Damage all bots
        my @bot_list = $entity_list->GetBotList();
        foreach my $bot (@bot_list) {
            next unless $bot;
            $bot->Damage($npc, 7500, 0, 1, 0);
        }

        quest::depop();
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("explode_timer");
}