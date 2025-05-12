sub EVENT_COMBAT {
    # Check if NPC has entered combat
    if ($combat_state == 1) {
        # Start a repeating timer to check health every second
        quest::settimer("check_hp", 1);
        # Start a repeating timer to cast a random spell every 50 seconds
        quest::settimer("random_spell", 50);
    } else {
        # Stop the timers when combat ends
        quest::stoptimer("check_hp");
        quest::stoptimer("random_spell");
    }
}

sub EVENT_TIMER {
    if ($timer eq "check_hp") {
        # Check if NPC's health is at or below 50%
        if ($npc->GetHPRatio() <= 50) {
            # Make the NPC immune to ranged and magic attacks
            $npc->SetSpecialAbility(46, 1); # Ranged immunity
            #$npc->SetSpecialAbility(20, 1); # Magic immunity
            # NPC shouts a message
            $npc->Shout("Closer mortal!");
            # Stop further checks to prevent re-triggering
            quest::stoptimer("check_hp");
        }
    } elsif ($timer eq "random_spell") {
        # Randomly select one of the three spells
        my @spells = (4187, 4186, 4189); # List of spell IDs
        my $random_spell = $spells[int(rand(@spells))];
        # Cast the selected spell on the NPC's target
        $npc->CastSpell($random_spell, $npc->GetHateTop()->GetID());
    }
}
