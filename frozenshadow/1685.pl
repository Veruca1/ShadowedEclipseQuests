sub EVENT_SPAWN {
    # Shout upon spawn
    quest::shout("Who is disrupting my prison!");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) { # Engaged in combat
        my $riot_triggered = 0; # Flag to track if the shout happens

        # Check the zone for NPCs with ID 1684
        foreach my $npc ($entity_list->GetNPCList()) {
            if ($npc->GetNPCTypeID() == 1684 && !$npc->IsEngaged()) {
                # Get the list of bots in the zone
                foreach my $bot ($entity_list->GetBotList()) {
                    # Add each bot to the hate list
                    $npc->AddToHateList($bot, 1); # Aggro onto Varketh's hate list
                }
                $riot_triggered = 1; # Set flag that riot is triggered
            }
        }

        # Shout "PRISON RIOT!!" if any 1684 NPCs are found
        if ($riot_triggered) {
            quest::shout("PRISON RIOT!!");
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Zone shout on death
    quest::shout("Noooooo! You have unleashed madness!");

    # Spawn Sirius Black (NPC ID 987654) at Varketh's death location
    quest::spawn2(1688, 0, 0, $x, $y, $z, $h); # Spawn at Varketh's last position
}
