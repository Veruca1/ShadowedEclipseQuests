my $lifedrain_active = 0; # Flag to track if lifedrain is active
my $damage_since_lifedrain = 0; # Track damage after life drain starts

sub EVENT_COMBAT {
    if ($combat_state == 1) { 
        # Combat started
        quest::shout("Prepare yourselves, mortals!");
        quest::setnexthpevent(75); # Set first HP trigger
    } elsif ($combat_state == 0) { 
        # Combat ended
        quest::stoptimer("lifedrain"); # Stop lifedrain if combat ends
        #quest::shout("You may have escaped this time...");
        $lifedrain_active = 0; # Reset lifedrain flag
        $damage_since_lifedrain = 0; # Reset damage counter after combat ends
    }
}

sub EVENT_HP {
    if ($hpevent == 75 && !$lifedrain_active) {
        quest::shout("You can't CALM your doomed fate! Feel the power of despair!");
        quest::settimer("lifedrain", 6); # Start PBAE lifedrain timer
        quest::setnexthpevent(25); # Set next HP trigger
        $lifedrain_active = 1; # Lifedrain is now active
        $damage_since_lifedrain = 0; # Reset damage counter when lifedrain starts
    } elsif ($hpevent == 25 && !$lifedrain_active) {
        quest::shout("You can't CALM your doomed fate! Your end is near!");
        quest::settimer("lifedrain", 6); # Keep PBAE lifedrain timer going
        $lifedrain_active = 1; # Lifedrain is now active
        $damage_since_lifedrain = 0; # Reset damage counter when lifedrain starts
    }
}

sub EVENT_TIMER {
    if ($timer eq "lifedrain") {
        if ($npc->IsEngaged() && $lifedrain_active) { # Ensure the NPC is in combat and lifedrain is active
            my $lifedrain_spell_id = 36942; # Replace with your spell ID
            quest::castspell($lifedrain_spell_id, $npc->GetID());
        } else {
            quest::stoptimer("lifedrain"); # Stop lifedrain if no combat or it was disabled
        }
    }
}

# This event fires when the NPC takes damage
sub EVENT_DAMAGE_TAKEN {
    if ($lifedrain_active) { # Only track damage after lifedrain starts
        $damage_since_lifedrain += $damage;  # Accumulate the additional damage taken by the NPC after life drain starts

        # Check if the damage since life drain started exceeds 100k
        if ($damage_since_lifedrain >= 100000) {
            if ($lifedrain_active) {  # Only stop lifedrain if it's active
                quest::stoptimer("lifedrain"); # Stop the lifedrain timer
                $lifedrain_active = 0; # Disable the lifedrain flag
                quest::shout("Enough! You have wounded me deeply, I will stop the drain for now!");
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::signalwith(1427, 13, 0); # Notify other NPCs or scripts
    quest::shout("Even in death, I will haunt you!");
    $lifedrain_active = 0; # Reset lifedrain flag on death
    $damage_since_lifedrain = 0; # Reset damage counter on death
}
