sub EVENT_SPAWN {
    # Shout when Jaled`Dar spawns
    quest::shout("Who has summoned me here? It's been so long, how can this be?!");

    # Stop any timers in case they're running from a previous spawn
    quest::stoptimer("fire_aoe");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # NPC is engaged in combat
        # Start a repeating timer for the spell cast every 60 seconds (1 minute)
        quest::settimer("fire_aoe", 60);
        quest::shout("Prepare to face my wrath!");
    } else {
        # Stop the timer when NPC leaves combat
        quest::stoptimer("fire_aoe");
    }
}

sub EVENT_TIMER {
    if ($timer eq "fire_aoe") {
        # Taunt message before casting the spell
        quest::shout("I will consume you with flames as I did Ganak!");

        # Handle the hate list to cast the spell
        my @hatelist = $npc->GetHateList();
        foreach my $n (@hatelist) {
            next unless defined $n;
            next unless $n->GetEnt();
            next if (!$n->GetEnt()->IsClient() && !$n->GetEnt()->IsBot());

            # Cast the spell 36856 on the first valid target
            $npc->SpellFinished(36856, $n->GetEnt()->CastToMob());
            last;  # Exit the loop after casting on the first valid target
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Stop the timer upon Jaled`Dar's death
    quest::stoptimer("fire_aoe");

    # Death shout related to the Ring of Scale and the Chronomancer
    quest::shout("My time in the Ring of Scale has ended... but time itself has been altered... Curse the meddling of the Chronomancer, for his actions have unraveled the very threads of fate!");
}
