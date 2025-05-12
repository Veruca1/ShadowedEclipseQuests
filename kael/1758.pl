sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has entered combat
        # Remove buffs immediately when the NPC engages in combat
        my $radius = 50;  # Set your desired radius (e.g., 50 units)
        foreach my $client ($entity_list->GetClientList()) {
            my $distance = $client->CalculateDistance($npc);
            if ($distance <= $radius) {
                # Fade each beneficial buff individually
                foreach my $buff_id ($client->GetBuffs()) {
                    $client->BuffFadeBySpellID($buff_id);  # Fades each buff individually
                }

                # Message to the client (player, bot, or pet)
                $client->Message(14, "Overseer Hragveld bashes you so hard that a buff fades from your body!");
            }
        }

        # Start the 40-second timer to continue removing buffs periodically
        quest::settimer("life_drain", 40);
    }
    elsif ($combat_state == 0) {
        # NPC has left combat, stop the life drain timer
        quest::stoptimer("life_drain");
    }
}

sub EVENT_TIMER {
    if ($timer eq "life_drain") {
        # Drain buffs from players, pets, and bots in the radius every 40 seconds
        my $radius = 50;  # Set your desired radius (e.g., 50 units)
        foreach my $client ($entity_list->GetClientList()) {
            my $distance = $client->CalculateDistance($npc);
            if ($distance <= $radius) {
                # Fade each beneficial buff individually
                foreach my $buff_id ($client->GetBuffs()) {
                    $client->BuffFadeBySpellID($buff_id);  # Fades each buff individually
                }

                # Message to the client (player, bot, or pet)
                $client->Message(14, "Overseer Hragveld bashes you so hard that a buff fades from your body!");
            }
        }

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1764, 7);
}
}
}