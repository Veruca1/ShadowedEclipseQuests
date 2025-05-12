sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # NPC has entered combat
        quest::settimer("spell_cast", 50);  # Set a timer to trigger every 50 seconds
    } else {
        # NPC has left combat
        quest::stoptimer("spell_cast");     # Stop the timer when combat ends
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cast") {
        # Pick a random spell from the two options
        my @spells = (36909, 36910);        # Array of spell IDs
        my $random_spell = $spells[int(rand(@spells))];  # Pick a random spell
        $npc->CastSpell($random_spell, $npc->GetHateTop()->GetID());  # Cast the spell on the target with the highest hate
    }
}

sub EVENT_DEATH_COMPLETE {
    # Sends signal 3 to NPC 1455 with a 2-second delay
    quest::signalwith(1455, 3, 2);
}
