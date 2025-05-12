sub EVENT_SPAWN {
    # Shout a message when NPC 1382 spawns
    quest::shout("Drusella, my Queen! Together, we shall paint these halls with their blood and reclaim our eternal reign to Kunark!");
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has entered combat, start the spell casting timer (every 40 seconds)
        quest::settimer("cast_spells", 40);

        # Immediately cast a random spell when combat starts
        my $target = $npc->GetHateTop();  # Get the top target from the hate list
        if ($target) {
            my @spells = (6795, 6799, 6794, 6796);  # Array of possible spells
            my $random_spell = $spells[int(rand(@spells))];  # Pick a random spell from the array
            quest::castspell($random_spell, $target->GetID());  # Cast the selected spell on the player
        }
    } elsif ($combat_state == 0) {
        # NPC has left combat, stop the spell casting timer
        quest::stoptimer("cast_spells");
    }
}

sub EVENT_TIMER {
    if ($timer eq "cast_spells") {
        # Check if still in combat before casting
        if ($npc->IsEngaged()) {
            # Randomly select a spell from the list
            my @spells = (6795, 6799, 6794, 6796);  # Array of possible spells
            my $random_spell = $spells[int(rand(@spells))];  # Pick a random spell from the array

            # Get the top hate target (player engaged in combat)
            my $target = $npc->GetHateTop();  # Get the top target from hate list

            if ($target) {
                # Cast the selected spell on the player
                quest::castspell($random_spell, $target->GetID());  # Cast the random spell on the player
            }
        }
    }
}
