sub EVENT_SPAWN {
    quest::settimer("aggro_tank", 1);
}

sub EVENT_TIMER {
    if ($timer eq "aggro_tank") {
        my $closest_tank;
        my $closest_dist = 99999;

        # Clients
        foreach my $client ($entity_list->GetClientList()) {
            next unless $client;
            my $class = $client->GetClass();
            next unless $class == 1 || $class == 3 || $class == 5;

            my $dist = $npc->CalculateDistance($client);
            if ($dist < $closest_dist) {
                $closest_dist = $dist;
                $closest_tank = $client;
            }
        }

        # Bots
        foreach my $bot ($entity_list->GetBotList()) {
            next unless $bot;
            my $class = $bot->GetClass();
            next unless $class == 1 || $class == 3 || $class == 5;

            my $dist = $npc->CalculateDistance($bot);
            if ($dist < $closest_dist) {
                $closest_dist = $dist;
                $closest_tank = $bot;
            }
        }

        if ($closest_tank) {
            $npc->AddToHateList($closest_tank, 10000);
        }

        quest::stoptimer("aggro_tank");
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 0) {
        quest::signalwith(164111, 101); # IMMEDIATE event reset on combat end
    }
}

sub EVENT_SIGNAL {
    if ($signal == 102) {
        quest::depop();
    }
}