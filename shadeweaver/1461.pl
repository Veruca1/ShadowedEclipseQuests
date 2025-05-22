sub EVENT_SPAWN {
    # Start a 20-second timer upon spawning
    quest::settimer("explode_timer", 20);
}

sub EVENT_TIMER {
    if ($timer eq "explode_timer") {
        quest::stoptimer("explode_timer");

        $npc->Emote("explodes in a violent surge of magic!");

        # Damage all players in the zone
        foreach my $client ($entity_list->GetClientList()) {
            $client->Damage($npc, 7500, 0, 1, false);

            # Damage their pet if it exists
            my $pet = $client->GetPet();
            if ($pet) {
                $pet->Damage($npc, 7500, 0, 1, false);
            }
        }

        # Damage all bots
        foreach my $bot ($entity_list->GetBotList()) {
            $bot->Damage($npc, 7500, 0, 1, false);
        }

        # Depop the NPC since it exploded
        quest::depop();
    }
}

# Optional: clear the timer if the NPC dies before 20 seconds (so no explosion after death)
sub EVENT_DEATH_COMPLETE {
    quest::stoptimer("explode_timer");
}