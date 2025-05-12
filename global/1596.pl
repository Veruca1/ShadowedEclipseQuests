# Healing Totem Script for NPC ID 1596

my $healing_spell_id = 40603;  # Spell ID for the healing spell

sub EVENT_SPAWN {
    # Start the timer to cast the healing spell every 4 seconds
    quest::settimer("heal_players", 4);
    # Start the timer to depop after 13 seconds
    quest::settimer("depop", 13);
}

sub EVENT_TIMER {
    if ($timer eq "heal_players") {
        # Get the list of players within range (adjust range if needed)
        my @players = $entity_list->GetClientList();
        foreach my $player (@players) {
            # Cast the healing spell on each player
            quest::castspell($healing_spell_id, $player->GetID());
        }
    }
    elsif ($timer eq "depop") {
        # Depop the NPC
        quest::depop();
    }
}

sub EVENT_DEATH_COMPLETE {
    # Cleanup timers when the NPC dies
    quest::stoptimer("heal_players");
    quest::stoptimer("depop");
}
