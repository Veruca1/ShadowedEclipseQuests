sub EVENT_COMBAT {
    if ($combat_state == 1) {
        quest::settimer("spell_cast", 30); # Start a 30-second timer when combat begins
    } else {
        quest::stoptimer("spell_cast");   # Stop the timer when combat ends
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cast") {
        # Randomly pick one of the two spells to cast
        my $random_spell = quest::ChooseRandom(40607, 40606);

        # Cast the chosen spell
        $npc->CastSpell($random_spell, $npc->GetTarget()->GetID());
    }
}
