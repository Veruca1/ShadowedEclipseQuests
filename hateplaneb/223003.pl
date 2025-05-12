my $totem_timer_active = 0;
my $skeleton_timer_active = 0;
my $no_challengers_message_sent = 0;  # Flag to prevent message spamming

sub EVENT_SPAWN {
    quest::gmsay("The Malignant Revenant has awakened! Prepare yourselves, mortals.", 14, 1, 0, 0);
    quest::settimer("phase_check", 1);        # Checks the phase based on boss HP every second
    quest::settimer("check_combat", 2);       # Check if the NPC is still in combat every 2 seconds
}

sub EVENT_TIMER {
    if ($timer eq "phase_check") {
        if ($npc->GetHPRatio() > 75) {
            Phase1_Mechanics();
        } elsif ($npc->GetHPRatio() <= 75 && $npc->GetHPRatio() > 40) {
            Phase2_Mechanics();
        } elsif ($npc->GetHPRatio() <= 40) {
            Phase3_Mechanics();
        }
    }

    if ($timer eq "totem_summon") {
        Summon_Totems();
    }

    if ($timer eq "skeleton_summon") {
        Summon_Skeletons();
    }

    if ($timer eq "check_combat") {
        if (!$npc->IsEngaged()) {
            # Stop all timers when not engaged
            quest::stoptimer("totem_summon");
            quest::stoptimer("skeleton_summon");
            $totem_timer_active = 0;
            $skeleton_timer_active = 0;
            
            # Send message only if not already sent
            if (!$no_challengers_message_sent) {
                quest::shout("The Revenant grows still as it senses no challengers.");
                $no_challengers_message_sent = 1;  # Set flag to prevent spamming
            }
        } else {
            # Restart the timers only if they are not already running
            if (!$totem_timer_active) {
                quest::settimer("totem_summon", 30);  # Restart totem summon timer
                $totem_timer_active = 1;
            }
            if (!$skeleton_timer_active) {
                quest::settimer("skeleton_summon", 37);  # Restart skeleton summon timer
                $skeleton_timer_active = 1;
            }
            
            # Reset flag when NPC is engaged
            if ($no_challengers_message_sent) {
                $no_challengers_message_sent = 0;  # Allow message to be sent again if needed
            }
        }
    }
}

sub EVENT_COMBAT {
    if ($combat_state == 1) {  # Combat starts
        quest::shout("You dare challenge me?");
        if (!$totem_timer_active) {
            quest::settimer("totem_summon", 30);
            $totem_timer_active = 1;
        }
        if (!$skeleton_timer_active) {
            quest::settimer("skeleton_summon", 37);
            $skeleton_timer_active = 1;
        }
    } elsif ($combat_state == 0) {  # Combat ends
        quest::shout("You cannot hide from me forever.");
        quest::stoptimer("totem_summon");
        quest::stoptimer("skeleton_summon");
        $totem_timer_active = 0;
        $skeleton_timer_active = 0;
    }
}

sub Phase1_Mechanics {
    quest::castspell(33633, $npc->GetID());  # Bone Shield spell
}

sub Phase2_Mechanics {
    quest::castspell(33634, $npc->GetID());  # Cursed Aura spell
    quest::castspell(33635, $npc->GetID());  # Shadow Vortex spell
}

sub Phase3_Mechanics {
    quest::castspell(33636, $npc->GetID());  # Blood Sacrifice spell
    quest::castspell(33637, $npc->GetID());  # Death's Grasp spell
}

sub Summon_Totems {
    my $totem_count = plugin::RandomRange(1, 3);  # Summons 1-3 totems randomly

    for (my $i = 0; $i < $totem_count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-10, 10);  # Randomize spawn location slightly
        my $y = $npc->GetY() + plugin::RandomRange(-10, 10);
        my $z = $npc->GetZ();
        quest::spawn2(1255, 0, 0, $x, $y, $z, $npc->GetHeading());  # Spawn the totem NPC
    }
}

sub Summon_Skeletons {
    my $skeleton_count = plugin::RandomRange(1, 2);  # Summons 1-2 skeletons

    for (my $i = 0; $i < $skeleton_count; $i++) {
        my $x = $npc->GetX() + plugin::RandomRange(-15, 15);  # Randomize spawn location
        my $y = $npc->GetY() + plugin::RandomRange(-15, 15);
        my $z = $npc->GetZ();
        quest::spawn2(1254, 0, 0, $x, $y, $z, $npc->GetHeading());  # Spawn the skeleton NPCs
    }
}

sub EVENT_DEATH_COMPLETE {
    quest::shout("The Malignant Revenant has been defeated!");  # End encounter message
    quest::stoptimer("phase_check");
    quest::stoptimer("totem_summon");
    quest::stoptimer("skeleton_summon");
    quest::stoptimer("check_combat");
    $totem_timer_active = 0;
    $skeleton_timer_active = 0;
    quest::depop();  # Ensures the NPC is fully removed from the game.
}
