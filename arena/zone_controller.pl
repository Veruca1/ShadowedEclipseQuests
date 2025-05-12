sub EVENT_SIGNAL {
    if ($signal == 10) {
        quest::ze(15, "$name explodes in a violent surge of magic!");

        # Damage all players
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
    }
}