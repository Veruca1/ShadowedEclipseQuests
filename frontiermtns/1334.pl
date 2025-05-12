sub EVENT_COMBAT {
    if ($combat_state == 1) {  # When combat starts
        quest::shout("The Greenmist will come again for you ALL!");  # Combat shout
        quest::settimer("random_cast", 40);  # Set timer for every 40 seconds
    } else {
        quest::stoptimer("random_cast");  # Stop the timer if combat ends
    }
}

sub EVENT_TIMER {
    if ($timer eq "random_cast") {
        # List of spells to cast (36860 and 36861)
        my @spells = (36860, 36861);
        
        # Pick a random spell from the list
        my $random_spell = $spells[rand @spells];
        
        if ($random_spell == 36860) {
            # Shout for Rage of the Displaced (36860)
            quest::shout("Feel my displaced rage!");
        } elsif ($random_spell == 36861) {
            # Shout for Timestorm (36861)
            quest::shout("The storm of time will consume you!");
        }
        
        # Cast the random spell on the NPC’s target
        $npc->CastSpell($random_spell, $npc->GetTarget()->GetID());
    }
}
