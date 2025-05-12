# When the NPC spawns, set initial values
sub EVENT_SPAWN {
    quest::shout("Who dares trifle with The Shadowed Eclipse?");
    quest::setnexthpevent(50);  # Set HP event for 50%
}

# Handle combat state changes
sub EVENT_COMBAT {
    if ($combat_state == 1) {
        # Set a timer for the NPC's tricks every 20 seconds
        quest::settimer("cleric_tricks", 20);
    } elsif ($combat_state == 0) {
        # Stop the tricks timer when combat ends
        quest::stoptimer("cleric_tricks");
    }
}

# Handle HP events
sub EVENT_HP {
    if ($hpevent == 50) {
        # Spawn NPC 44004 at the same location
        quest::shout("Someone who used to reside here wishes to speak with you!");
        quest::spawn2(44004, 0, 0, $x, $y, $z, $h);
    }
}

# Handle timer events
sub EVENT_TIMER {
    if ($timer eq "cleric_tricks") {
        if ($combat_state == 1) {
            my $random_trick = quest::ChooseRandom(1, 2, 3);
            if ($random_trick == 1) {
                # Resurrect a slain ally at a specific location and heading
                quest::shout("Let's resurrect one of your old friends!");
                my $resurrected_npc_id = quest::ChooseRandom(1169, 1170, 63021);
                quest::spawn2($resurrected_npc_id, 0, 0, 353.44, -19.32, 4.37, 153.50);
            } elsif ($random_trick == 2) {
                # Reduce the target's HP by 1000
                my $target = $npc->GetHateTop();
                if ($target) {
                    quest::shout("Take this!");
                    my $target_hp = $target->GetHP();
                    $target->SetHP($target_hp - 1000);
                }
            } elsif ($random_trick == 3) {
                # Apply Divine Retribution debuff on the target
                my $target = $npc->GetHateTop();
                if ($target) {
                    quest::shout("Xyron demands retribution!");
                    $npc->CastSpell(2507, $target->GetID());
                }
            }
        }
    }
}

# Handle NPC death
sub EVENT_DEATH_COMPLETE {
    quest::shout("Mark my words, heathens, your bones will litter these halls if you proceed!");
    quest::stoptimer("cleric_tricks");
}
