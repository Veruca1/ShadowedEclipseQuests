my $phase = 1;
my $spell_cycle_counter = 0;  # Counter to track spell casting order
my $message_sent_corrupting_strike = 0;
my $message_sent_frenzy = 0;
my $message_sent_poison_gas = 0;

sub EVENT_SPAWN {
    quest::settimer("spell_cycle", 10);  # Start the spell cycle timer
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat started
        # Reset message flags and counter
        $message_sent_corrupting_strike = 0;
        $message_sent_frenzy = 0;
        $message_sent_poison_gas = 0;
        $spell_cycle_counter = 0;

        # Send a marquee message on engagement
        quest::ze(15, "The Fabled Ghoul Lord begins his assault!");
        quest::settimer("spell_cycle", 10);  # Start or restart the spell cycle timer
    } else {
        quest::stoptimer("spell_cycle");  # Stop the spell cycle timer
    }
}

sub EVENT_TIMER {
    if ($timer eq "spell_cycle") {
        my $target = $npc->GetHateTop();  # Get the top hate target (usually a player or bot)

        # Ensure spell casting is based on engagement and there's a valid target
        if ($combat_state == 1 && $target) {
            # Alternate spell casting in a sequence
            if ($spell_cycle_counter == 0) {
                # Cast Poison Gas
                quest::castspell(4162, $npc->GetID());
                if (!$message_sent_poison_gas) {
                    quest::ze(15, "Poisonous gas seeps from the Fabled Ghoul Lord's wounds!");
                    $message_sent_poison_gas = 1;
                }
                $spell_cycle_counter = 1;
            } elsif ($spell_cycle_counter == 1) {
                # Cast Corrupting Strike on the target
                quest::castspell(33643, $target->GetID());
                if (!$message_sent_corrupting_strike) {
                    quest::ze(15, "The Fabled Ghoul Lord's strikes are corrupting!");
                    $message_sent_corrupting_strike = 1;
                }
                $spell_cycle_counter = 2;
            } elsif ($spell_cycle_counter == 2) {
                # Cast Ghoul Frenzy on himself
                quest::castspell(33644, $npc->GetID());
                if (!$message_sent_frenzy) {
                    quest::ze(15, "The Fabled Ghoul Lord enters a frenzied state, his strikes growing faster and draining life!");
                    $message_sent_frenzy = 1;
                }
                $spell_cycle_counter = 0;
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    # Spawn NPC 1508 if it doesn't already exist
    if (!quest::isnpcspawned(1508)) {
        quest::spawn2(1508, 0, 0, $x, $y, $z, $h);
    }
    quest::ze(15, "The Fabled Ghoul Lord has been defeated!");
    quest::stoptimer("spell_cycle");  # Stop the spell cycle timer
}
